public extern int fake_ft_printf (string fmt, void* list, void* func);
Module? libftprintf = null;
void* ft_printf_sym = null;

void load_ft_printf (string path) {
	libftprintf = Module.open (path, ModuleFlags.LAZY);
	if (libftprintf == null) {
		printerr ("%s\n", Module.error ());
		Process.exit (1);
	}
	if (!libftprintf.symbol ("ft_printf", out ft_printf_sym) || ft_printf_sym == null) {
		printerr ("%s\n", Module.error ());
		Process.exit (1);
	}
}
[CCode (cname = "vprintf")]
public extern int real_ft_printf (string fmt, void* list);

[CCode (cname = "TEST", cheader_filename = "test.h", sentinel = "")]
public extern void test(string format, ...);

public const string RED = "\033[31m";
public const string REDL = "\033[91m";
public const string YELLOW = "\033[93m";
public const string GREEN = "\033[32m";
public const string NONE = "\033[0m";
public const string PURPLE = "\033[35m";
public const string POINT = YELLOW + "  ➜ " + NONE;

public async string async_test_impl(string txt, string format, void* ptr1, void* ptr2){
	
	int ret1 = 0;
	int ret2 = 0;
	SupraTest.Test? res_you = null;
	SupraTest.Test? res_real = null;
	int pending = 2;

	SupraTest.complex.begin (2, () => {
		ret1 = fake_ft_printf (format, ptr1, ft_printf_sym);
		return true;
	}, "", (obj, res) => {
		res_you = SupraTest.complex.end (res);
		if (--pending == 0)
			async_test_impl.callback ();
	});

	SupraTest.complex.begin (2, () => {
		ret2 = real_ft_printf (format, ptr2);
		return true;
	}, "", (obj, res) => {
		res_real = SupraTest.complex.end (res);
		if (--pending == 0)
			async_test_impl.callback ();
	});

	yield;

	bool b = true;
	var sb = new StringBuilder();

	if (ret1 != ret2) {
		sb.append_printf(POINT + REDL + "return value You: \033[95m%d" + REDL + ", Me: \033[96m%d\n", ret1, ret2);
		b = false;
	}

	if (res_you.stdout != res_real.stdout) {
		sb.append_printf(POINT + REDL + "output differs: \033[35m\n   •You: \033[95m%s\033[35m\033[0m\n   \033[36m•Me: \033[96m%s\033[0m\n", res_you.stdout, res_real.stdout);
		b = false;
	}

	if (b == false) {
		const string str = RED + "\n[KO] " + YELLOW + "printf(%s)" + YELLOW + "\n%s";
		return str.printf(txt, sb.str);
	}
	return res_you.msg();

}

public void test_impl(string txt, string format, ...) {
	nb_tests_start += 1;
	while (running >= get_num_processors())
			MainContext.default().iteration(true);
	var lst1 = va_list();
	var lst2 = va_list.copy(lst1);
	void* ptr1 = (void*)lst1;
	void* ptr2 = (void*)lst2;

	running += 1;
	async_test_impl.begin(txt, format, ptr1, ptr2, (obj, res) => {
		var result = async_test_impl.end(res);
		print ("%s", result);
		running -= 1;
		nb_tests_finish += 1;
	});
}

private uint running = 0;
private uint nb_tests_start = 0;
private uint nb_tests_finish = 0;

public async void describe(string? txt) {

	while (nb_tests_start != nb_tests_finish) {
		Idle.add(describe.callback);
		yield;
	}
	if (txt == null)
		return;
	print("\n%s\n", txt);
}
