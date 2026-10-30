#ifndef TEST_MACRO_H
#define TEST_MACRO_H
#include <stdio.h>
#include <sys/types.h>

typedef int (*SupraPrintf)(const char *, ...);
typedef struct {
    int out_fd, err_fd, result_fd, status, timed_out, setup_error;
    pid_t pid;
} SupraCapture;
void supra_set_student(void *function);
SupraPrintf supra_student(void);
SupraPrintf supra_reference(void);
int supra_capture_start(SupraCapture *capture);
void supra_capture_exit(SupraCapture *capture, int result) __attribute__((noreturn));
void supra_capture_wait(SupraCapture *capture);
void supra_compare(const char *source, SupraCapture *student, SupraCapture *reference);
unsigned supra_total(void);
unsigned supra_failed(void);
unsigned supra_errors(void);
int supra_exit_status(void);
void supra_forbidden(void);

/* Fork before the argument expressions leave scope. The compiler marshals both
 * calls for the current ABI; no saved va_list or assembly trampoline is needed. */
#define TEST(fmt, ...) do { \
    SupraCapture supra_you, supra_real; \
    if (supra_capture_start(&supra_you) == 0) { \
        int supra_ret = supra_student()(fmt, ##__VA_ARGS__); \
        supra_capture_exit(&supra_you, supra_ret); \
    } \
    supra_capture_wait(&supra_you); \
    if (supra_capture_start(&supra_real) == 0) { \
        int supra_ret = supra_reference()(fmt, ##__VA_ARGS__); \
        supra_capture_exit(&supra_real, supra_ret); \
    } \
    supra_capture_wait(&supra_real); \
    supra_compare(#fmt ", " #__VA_ARGS__, &supra_you, &supra_real); \
} while (0)
#endif
