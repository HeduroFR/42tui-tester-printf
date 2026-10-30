#define _POSIX_C_SOURCE 200809L
#include "test.h"
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#ifdef __linux__
#include <sys/prctl.h>
#endif
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define OUTPUT_LIMIT (1024 * 1024)
#define CASE_SECONDS 2
extern void supra_prepare_child(void);
extern int supra_child_allocations(void);
extern int supra_child_frees(void);
static SupraPrintf student_function;
static unsigned total, failed, errors, forbidden;
typedef struct { int returned, allocations, frees; } Result;

void supra_set_student(void *function) { student_function = (SupraPrintf) function; }
SupraPrintf supra_student(void) { return student_function; }
SupraPrintf supra_reference(void) { return printf; }
unsigned supra_total(void) { return total; }
unsigned supra_failed(void) { return failed; }
unsigned supra_errors(void) { return errors; }
int supra_exit_status(void) { return failed || errors || forbidden ? 1 : 0; }
void supra_forbidden(void) { forbidden++; total++; failed++; }

static int temporary(void) {
    const char *base = getenv("TMPDIR");
    if (!base || !*base) base = "/tmp";
    size_t length = strlen(base) + sizeof("/supra-XXXXXX");
    char *path = malloc(length);
    if (!path) return -1;
    snprintf(path, length, "%s/supra-XXXXXX", base);
    int fd = mkstemp(path);
    if (fd >= 0) unlink(path);
    free(path);
    return fd;
}
static void close_capture(SupraCapture *c) {
    if (c->out_fd >= 0) close(c->out_fd);
    if (c->err_fd >= 0) close(c->err_fd);
    if (c->result_fd >= 0) close(c->result_fd);
}
static double now(void) {
    struct timespec value;
    if (clock_gettime(CLOCK_MONOTONIC, &value) != 0) return -1;
    return value.tv_sec + value.tv_nsec / 1e9;
}
int supra_capture_start(SupraCapture *c) {
    *c = (SupraCapture) {.out_fd = -1, .err_fd = -1, .result_fd = -1, .pid = -1};
    c->out_fd = temporary(); c->err_fd = temporary(); c->result_fd = temporary();
    if (c->out_fd < 0 || c->err_fd < 0 || c->result_fd < 0 || fflush(NULL) != 0) {
        c->setup_error = 1; return -1;
    }
    pid_t parent = getpid();
    c->pid = fork();
    if (c->pid < 0) { c->setup_error = 1; return -1; }
    if (c->pid == 0) {
#ifdef __linux__
        // Do not leave an infinite-loop test alive after cancellation/watchdog death.
        if (prctl(PR_SET_PDEATHSIG, SIGKILL) != 0 || getppid() != parent) _exit(120);
#else
        (void)parent;
#endif
        if (setpgid(0, 0) != 0 || dup2(c->out_fd, STDOUT_FILENO) < 0 || dup2(c->err_fd, STDERR_FILENO) < 0) _exit(120);
        struct rlimit limit = {OUTPUT_LIMIT, OUTPUT_LIMIT};
        if (setrlimit(RLIMIT_FSIZE, &limit) != 0) _exit(120);
        supra_prepare_child();
        return 0;
    }
    // Establish the group before timeout cleanup, even if the child is delayed.
    if (setpgid(c->pid, c->pid) != 0 && errno != EACCES && errno != ESRCH) c->setup_error = 1;
    return 1;
}
void supra_capture_exit(SupraCapture *c, int returned) {
    // Snapshot student allocations before stdio flushing can allocate internally.
    Result result = {returned, supra_child_allocations(), supra_child_frees()};
    if (fflush(NULL) != 0 || write(c->result_fd, &result, sizeof(result)) != sizeof(result)) _exit(120);
    _exit(0);
}
void supra_capture_wait(SupraCapture *c) {
    if (c->pid <= 0) return;
    double started = now();
    if (started < 0) c->setup_error = 1;
    while (1) {
        siginfo_t info = {0};
        int observed = waitid(P_PID, (id_t)c->pid, &info, WEXITED | WNOHANG | WNOWAIT);
        // Keep the leader unreaped until group cleanup, preventing PID reuse.
        if (observed == 0 && info.si_pid == c->pid) break;
        if (observed < 0 && errno != EINTR) {
            c->setup_error = 1;
            return;
        }
        double current = now();
        if (c->setup_error || current < 0 || current - started >= CASE_SECONDS) {
            c->timed_out = !c->setup_error && current >= 0;
            if (current < 0) c->setup_error = 1;
            break;
        }
        struct timespec delay = {0, 1000000};
        nanosleep(&delay, NULL);
    }
    // Test code must not leave descendants holding captures or consuming CPU.
    kill(-c->pid, SIGKILL);
    kill(c->pid, SIGKILL);
    pid_t reaped;
    do { reaped = waitpid(c->pid, &c->status, 0); } while (reaped < 0 && errno == EINTR);
    if (reaped != c->pid) c->setup_error = 1;
}
static int result(SupraCapture *c, Result *r) {
    return !c->setup_error && !c->timed_out && WIFEXITED(c->status) && WEXITSTATUS(c->status) == 0
        && pread(c->result_fd, r, sizeof(*r), 0) == sizeof(*r);
}
static int same_output(int a, int b) {
    unsigned char left[4096], right[4096];
    off_t offset = 0;
    while (offset <= OUTPUT_LIMIT) {
        ssize_t na = pread(a, left, sizeof(left), offset), nb = pread(b, right, sizeof(right), offset);
        if (na < 0 || nb < 0) return -1;
        if (na != nb || memcmp(left, right, (size_t)na)) return 0;
        if (!na) return 1;
        offset += na;
    }
    return -1;
}
static void detail(int fd) {
    unsigned char bytes[512];
    ssize_t size = pread(fd, bytes, sizeof(bytes), 0);
    for (ssize_t i = 0; i < size; i++) {
        unsigned char ch = bytes[i];
        if (ch == '\n') fputs("\\n", stdout);
        else if (ch == '\0') fputs("\\0", stdout);
        else if (ch >= 32 && ch < 127) putchar(ch);
        else printf("\\x%02x", ch);
    }
    if (size == sizeof(bytes)) fputs("…", stdout);
}
void supra_compare(const char *source, SupraCapture *you, SupraCapture *real) {
    Result a = {0}, b = {0};
    int yours = result(you, &a), reference = result(real, &b);
    int equal = yours && reference ? same_output(you->out_fd, real->out_fd) : 0;
    total++;
    if (you->setup_error || real->setup_error || !reference || equal < 0) {
        errors++; printf("\033[31m[ERROR]\033[0m %s: capture/reference failed\n", source);
    } else if (!yours || !equal || a.returned != b.returned || a.allocations != a.frees) {
        failed++;
        const char *reason = you->timed_out ? "TIMEOUT" : !yours ? "CRASH" : a.allocations != a.frees ? "LEAK" : "KO";
        printf("\033[31m[%s]\033[0m %s\n", reason, source);
        if (yours) {
            printf("  return: You=%d Me=%d; allocations=%d frees=%d\n", a.returned, b.returned, a.allocations, a.frees);
            if (!equal) { fputs("  You: ", stdout); detail(you->out_fd); fputs("\n  Me:  ", stdout); detail(real->out_fd); putchar('\n'); }
        }
        fputs("  stderr: ", stdout); detail(you->err_fd); putchar('\n');
    } else fputs("\033[32m[OK]\033[0m", stdout);
    fflush(stdout);
    close_capture(you); close_capture(real);
}
