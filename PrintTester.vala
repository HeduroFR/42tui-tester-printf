Module? libftprintf = null;

[CCode (cname = "supra_set_student", cheader_filename = "test.h")]
public extern void set_student(void* function);
[CCode (cname = "supra_total", cheader_filename = "test.h")]
public extern uint total_tests();
[CCode (cname = "supra_failed", cheader_filename = "test.h")]
public extern uint failed_tests();
[CCode (cname = "supra_errors", cheader_filename = "test.h")]
public extern uint error_tests();
[CCode (cname = "supra_exit_status", cheader_filename = "test.h")]
public extern int tester_exit_status();
[CCode (cname = "supra_forbidden", cheader_filename = "test.h")]
public extern void record_forbidden();

void load_ft_printf(string path) {
    libftprintf = Module.open(path, ModuleFlags.LAZY);
    void* function = null;
    if (libftprintf == null || !libftprintf.symbol("ft_printf", out function) || function == null) {
        printerr("Cannot load ft_printf: %s\n", Module.error());
        Process.exit(2);
    }
    set_student(function);
}
[CCode (cname = "TEST", cheader_filename = "test.h", sentinel = "")]
public extern void test(string format, ...);

// These hooks run in each isolated child and preserve the upstream allocator checks.
[CCode (cname = "supra_prepare_child")]
public void prepare_child() { SupraLeak.reset(); }
[CCode (cname = "supra_child_allocations")]
public int child_allocations() { return SupraLeak.malloc; }
[CCode (cname = "supra_child_frees")]
public int child_frees() { return SupraLeak.free; }

public async void describe(string? title) {
    if (title != null) print("\n%s\n", title);
}
