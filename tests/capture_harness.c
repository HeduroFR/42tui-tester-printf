#include "test.h"
#include <stdarg.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
static const char *mode;
void supra_prepare_child(void) {}
int supra_child_allocations(void) { return !strcmp(mode, "leak") ? 1 : 0; }
int supra_child_frees(void) { return 0; }
static int student(const char *format, ...) {
    if (!strcmp(mode, "crash")) raise(SIGSEGV);
    if (!strcmp(mode, "timeout")) for (;;) {}
    if (!strcmp(mode, "binary")) { fwrite("a\0wrong", 1, 7, stdout); return 7; }
    va_list args;
    va_start(args, format);
    int result = vprintf(format, args);
    va_end(args);
    return result + (!strcmp(mode, "return"));
}
int main(int argc, char **argv) {
    if (argc != 2) return 2;
    mode = argv[1];
    supra_set_student((void *)student);
    if (!strcmp(mode, "good")) {
        TEST("%c%s|%p|%d|%u|%x|%%", 0, "text", (void *)0, -42, 42u, 255u);
        TEST("%d%d%d%d%d%d%d%d%d%d%d%d", 1,2,3,4,5,6,7,8,9,10,11,12);
        TEST("%s|%c|%08x|%.3s", (char *)0, 0, 0x42u, "hello");
        TEST("%%");
    } else if (!strcmp(mode, "binary")) TEST("a%c%s", 0, "right");
    else TEST("%s", "hello");
    printf("\ncounts %u %u %u\n", supra_total(), supra_failed(), supra_errors());
    return supra_exit_status();
}
