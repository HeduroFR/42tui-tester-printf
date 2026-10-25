

bool option_bonus = false;

const OptionEntry[] options = {
	{ "bonus", '\0', OptionFlags.NONE, OptionArg.NONE, ref option_bonus, "Build and test the bonus part", null },
	{ null }
};

async void main(string[] args)
{
	Intl.setlocale();
	try {
		var opt_context = new OptionContext ();
		opt_context.set_help_enabled (true);
		opt_context.add_main_entries (options, null);
		opt_context.parse (ref args);
	}
	catch (OptionError e) {
		stderr.printf ("\033[31m[SupraTest]\033[0m %s\n", e.message);
		stderr.printf ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
		return;
	}

	string libftprintf_so;
	try {
		libftprintf_so = find_libftprintf ();
	}
	catch (Error e) {
		stderr.printf ("\033[31m[SupraTest]\033[0m %s", e.message);
		return;
	}
	load_ft_printf (libftprintf_so);

	yield describe("Text Test");
	test_text();
	yield describe("%% Test");
	test_percent();
	yield describe("%c Test");
	test_char();
	test_char_around();
	yield describe("%s Test");
	test_string();
	yield describe("%p Test");
	test_pointer();
	yield describe("%d Test");
	test_d();
	yield describe("%i Test");
	test_i();
	yield describe("%u Test");
	test_u();
	yield describe("%x Test");
	test_x();
	yield describe("%X Test");
	test_upper_x();
	yield describe("Mix Test");
	test_mix();
	if (option_bonus)
		yield run_bonus_tests();
	yield describe(null);

	try {
		check_forbidden_functions (libftprintf_so);
	}
	catch (Error e) {
		stderr.printf ("\033[31m[SupraTest]\033[0m %s", e.message);
	}
	remove_tmp_dir (Path.get_dirname (libftprintf_so));
}

void check_forbidden_functions (string library_path) throws Error {
	print ("\n\033[33m     <------------- [ Forbidden functions ] ------------->\n\033[0m");
	string output;
	string errput;
	int status;

	Process.spawn_sync (null, {"nm", library_path}, null, SpawnFlags.SEARCH_PATH, null, out output, out errput, out status);
	if (status != 0) {
		stderr.printf ("\033[31m[SupraTest] Error while checking forbidden functions\033[0m\n");
		stderr.printf("%s\n", errput);
		return;
	}

	var sp = output.split ("\n");
	const string []allowed = {
		"write",
		"malloc",
		"free",
		"__stack_chk_fail",
		"__assert_fail",
		"__divdi3",
		"__moddi3",
		"__udivdi3",
		"__umoddi3",
		"__overflow",
		"__addv",
		"__subv",
		"__mulv",
		"__builtin_trap",
		"__fortify_fail",
		"__cxa_throw",
		"__cxa_rethrow",
		"__cxa_atexit",
		"__cxa_finalize",
		"__gcc_personality_v0"
	};

	bool is_good = true;
	foreach (unowned var line in sp) {
		if (" U " in line) {
			unowned string func_name = line.offset(line.index_of (" U ") + 3);
			func_name._delimit ("@", '\0');
			if (!(func_name in allowed)) {
				print ("\033[91m[Forbidden Function]: \033[31m%s !\033[0m\n", func_name);
				is_good = false;
			}
		}
	}
	if (is_good)
		print ("\033[32mNo forbidden function found !\033[0m\n");
}


private void test_char () {
	test("%c", 0); test("%c", 1); test("%c", 2); test("%c", 3); test("%c", 4); test("%c", 5);
	test("%c", 6); test("%c", 7); test("%c", 8); test("%c", 9); test("%c", 10); test("%c", 11);
	test("%c", 12); test("%c", 13); test("%c", 14); test("%c", 15); test("%c", 16); test("%c", 17);
	test("%c", 18); test("%c", 19); test("%c", 20); test("%c", 21); test("%c", 22); test("%c", 23);
	test("%c", 24); test("%c", 25); test("%c", 26); test("%c", 27); test("%c", 28); test("%c", 29);
	test("%c", 30); test("%c", 31); test("%c", ' '); test("%c", '!'); test("%c", '"'); test("%c", '#');
	test("%c", '$'); test("%c", '%'); test("%c", '&'); test("%c", '\''); test("%c", '('); test("%c", ')');
	test("%c", '*'); test("%c", '+'); test("%c", ','); test("%c", '-'); test("%c", '.'); test("%c", '/');
	test("%c", '0'); test("%c", '1'); test("%c", '2'); test("%c", '3'); test("%c", '4'); test("%c", '5');
	test("%c", '6'); test("%c", '7'); test("%c", '8'); test("%c", '9'); test("%c", ':'); test("%c", ';');
	test("%c", '<'); test("%c", '='); test("%c", '>'); test("%c", '?'); test("%c", '@'); test("%c", 'A');
	test("%c", 'B'); test("%c", 'C'); test("%c", 'D'); test("%c", 'E'); test("%c", 'F'); test("%c", 'G');
	test("%c", 'H'); test("%c", 'I'); test("%c", 'J'); test("%c", 'K'); test("%c", 'L'); test("%c", 'M');
	test("%c", 'N'); test("%c", 'O'); test("%c", 'P'); test("%c", 'Q'); test("%c", 'R'); test("%c", 'S');
	test("%c", 'T'); test("%c", 'U'); test("%c", 'V'); test("%c", 'W'); test("%c", 'X'); test("%c", 'Y');
	test("%c", 'Z'); test("%c", '['); test("%c", '\\'); test("%c", ']'); test("%c", '^'); test("%c", '_');
	test("%c", '`'); test("%c", 'a'); test("%c", 'b'); test("%c", 'c'); test("%c", 'd'); test("%c", 'e');
	test("%c", 'f'); test("%c", 'g'); test("%c", 'h'); test("%c", 'i'); test("%c", 'j'); test("%c", 'k');
	test("%c", 'l'); test("%c", 'm'); test("%c", 'n'); test("%c", 'o'); test("%c", 'p'); test("%c", 'q');
	test("%c", 'r'); test("%c", 's'); test("%c", 't'); test("%c", 'u'); test("%c", 'v'); test("%c", 'w');
	test("%c", 'x'); test("%c", 'y'); test("%c", 'z'); test("%c", '{'); test("%c", '|'); test("%c", '}');
	test("%c", '~'); test("%c", 127); test("%c", 128); test("%c", 129); test("%c", 130); test("%c", 131);
	test("%c", 132); test("%c", 133); test("%c", 134); test("%c", 135); test("%c", 136); test("%c", 137);
	test("%c", 138); test("%c", 139); test("%c", 140); test("%c", 141); test("%c", 142); test("%c", 143);
	test("%c", 144); test("%c", 145); test("%c", 146); test("%c", 147); test("%c", 148); test("%c", 149);
	test("%c", 150); test("%c", 151); test("%c", 152); test("%c", 153); test("%c", 154); test("%c", 155);
	test("%c", 156); test("%c", 157); test("%c", 158); test("%c", 159); test("%c", 160); test("%c", 161);
	test("%c", 162); test("%c", 163); test("%c", 164); test("%c", 165); test("%c", 166); test("%c", 167);
	test("%c", 168); test("%c", 169); test("%c", 170); test("%c", 171); test("%c", 172); test("%c", 173);
	test("%c", 174); test("%c", 175); test("%c", 176); test("%c", 177); test("%c", 178); test("%c", 179);
	test("%c", 180); test("%c", 181); test("%c", 182); test("%c", 183); test("%c", 184); test("%c", 185);
	test("%c", 186); test("%c", 187); test("%c", 188); test("%c", 189); test("%c", 190); test("%c", 191);
	test("%c", 192); test("%c", 193); test("%c", 194); test("%c", 195); test("%c", 196); test("%c", 197);
	test("%c", 198); test("%c", 199); test("%c", 200); test("%c", 201); test("%c", 202); test("%c", 203);
	test("%c", 204); test("%c", 205); test("%c", 206); test("%c", 207); test("%c", 208); test("%c", 209);
	test("%c", 210); test("%c", 211); test("%c", 212); test("%c", 213); test("%c", 214); test("%c", 215);
	test("%c", 216); test("%c", 217); test("%c", 218); test("%c", 219); test("%c", 220); test("%c", 221);
	test("%c", 222); test("%c", 223); test("%c", 224); test("%c", 225); test("%c", 226); test("%c", 227);
	test("%c", 228); test("%c", 229); test("%c", 230); test("%c", 231); test("%c", 232); test("%c", 233);
	test("%c", 234); test("%c", 235); test("%c", 236); test("%c", 237); test("%c", 238); test("%c", 239);
	test("%c", 240); test("%c", 241); test("%c", 242); test("%c", 243); test("%c", 244); test("%c", 245);
	test("%c", 246); test("%c", 247); test("%c", 248); test("%c", 249); test("%c", 250); test("%c", 251);
	test("%c", 252); test("%c", 253); test("%c", 254); test("%c", 255);
}

private void test_char_around () {
	test(" %c", 'a');
	test("%c ", 'a');
	test(" %c ", 'a');
	test("  %c  ", 'a');
	test(" %c ", ' ');
	test(" %c ", 0);
	test(" %c", '0' - 256);
	test("%c ", '0' + 256);
	test(" %c ", 0x220);
	test(" %c ", -1);
	test(" %c ", -129);
	test("%c%c", 'a', 'b');
	test("%c%c%c", ' ', ' ', ' ');
	test(" %c %c %c ", '0', 0, '1');
	test(" %c %c %c ", ' ', ' ', ' ');
	test(" %c %c %c ", '1', '2', '3');
	test(" %c %c %c ", '2', '1', 0);
	test(" %c %c %c ", 0, '1', '2');
	test("%c%c%c%c%c", 0, 0, 0, 0, 0);
	test("%c%c%c%c%c", 'H', 'e', 'l', 'l', 'o');
	test("%cc%cc%c", 'a', '\t', 'b');
	test("%cs%cs%c", 'c', 'b', 'a');
	test("%c%c%c", 'a', '\t', 'b');
	test("\t%c\n", 'x');
	test("\n%c\n%c\n", 'x', 'y');
	test("[%c]", 'x');
	test("[%c]", 0);
	test("(%c)(%c)", '(', ')');
	test("%c%%", 'x');
	test("%%%c", 'x');
	test("%%%c%%", '%');
	test("%c", '%');
	test("%c%c", '%', 'c');
	test("char: '%c', next: '%c'", 'a', 'z');
	test("sdf sdfsdf sd %c\t\v%c", 'h', 'a');
	test("%c%c\n", '\0', '~');
	test("%c is a letter and %c is a digit", 'a', '7');
	test("%c%s%c", '"', "quoted", '"');
	test("%c%d%c", '<', 42, '>');
	test("%c %c %c %c %c %c %c %c %c %c", 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j');
}

private void test_text () {
	test("");
	test("hello, world!");
	test("\t\n\r\v\f\n");
	test("\x01\x02\x07\v\b\f\r\n");
	test("no conversion at all, just some text");
}

private void test_percent () {
	test("%%");
	test(" %%");
	test("%% ");
	test(" %% ");
	test("%%%%");
	test("%%%%%%");
	test(" %% %% %% ");
	test(" %%  %%  %% ");
	test("%%c");
	test("100%%");
	test("%%%c", 'x');
	test("%%a%%a%%");
}

private void test_string () {
	string very_long = string.nfill (5000, 'a');

	test("%s", "");
	test(" %s", "");
	test("%s ", "");
	test(" %s ", "");
	test("%s", "%s%s%s%s");
	test("%s", "%s%s nda-cunh %s%s");
	test("%s", "%s%snda-cunh%s%s");
	test("%s", "Hello");
	test("%s", "  nda-cunh  ");
	test("%s", "Supra Corp");
	test(" %s ", "-");
	test(" %s %s ", "", "-");
	test(" %s %s ", " - ", "");
	test(" %s %s %s %s %s ", " - ", "", "4", "", "2 ");
	test("%s", (string?)null);
	test(" NULL %s NULL ", (string?)null);
	test("%s%s", (string?)null, (string?)null);
	test("%s", "\0abc");
	test("%s%s", "sdfd\0fs", "asdfasdf");
	test("%s", "some string with %s hehe");
	test(" %s", "can it handle \t and \n?");
	test("%sx", "{} al$#@@@^&$$^#^@@^$*((&");
	test("%s%s%s", "And ", "some", "joined");
	test("%ss%ss%ss", "And ", "some other", "joined");
	test("%s", "éàü€ unicode ✓");
	test("%s", very_long);
}

private void test_pointer () {
	int local = 42;
	int *addr = &local;

	test("%p", null);
	test(" %p ", null);
	test(" %p %p ", null, null);
	test("%p", "");
	test("%p", addr);
	test("a:%pb:%p", addr, &very_static);
	test(" %p ", (void*)1);
	test(" %p ", (void*)15);
	test(" %p ", (void*)16);
	test(" %p ", (void*)17);
	test(" %p ", (void*)(-1));
	test(" %p ", (void*)(-14523));
	test(" %p %p ", (void*)long.MIN, (void*)long.MAX);
	test(" %p %p ", (void*)int.MIN, (void*)int.MAX);
	test(" %p %p ", (void*)ulong.MAX, (void*)(-ulong.MAX));
	test("0x%p-", (void*)ulong.MAX);
	test("%pp%p%p", (void*)(long.MAX - 423856), null, (void*)int.MAX);
}
private int very_static = 0;

private void test_d () {
	test(" %d ", -1);
	test(" %d ", -10);
	test(" %d ", -100);
	test(" %d ", -101);
	test(" %d ", -11);
	test(" %d ", -200000);
	test(" %d ", -9);
	test(" %d ", -99);
	test(" %d ", 0);
	test(" %d ", 1);
	test(" %d ", 10);
	test(" %d ", 100);
	test(" %d ", 101);
	test(" %d ", 11);
	test(" %d ", 15);
	test(" %d ", 16);
	test(" %d ", 17);
	test(" %d ", 9);
	test(" %d ", 99);
	test(" %d ", int.MAX);
	test(" %d ", int.MIN);
	test(" %d ", 0x80000000);
	test(" %d ", long.MAX);
	test(" %d ", long.MIN);
	test(" %d ", uint.MAX);
	test(" %d ", ulong.MAX);
	test(" %d ", 122342342423);
	test("%d%d", 24, -24);
	test("%dd%dd%d", 1, -2, 3);
	test(" %d %d %d %d %d %d %d", int.MAX, int.MIN, long.MAX, long.MIN, ulong.MAX, 0, -42);
}

private void test_i () {
	test(" %i ", 0);
	test(" %i ", -1);
	test(" %i ", 1);
	test(" %i ", 9);
	test(" %i ", 10);
	test(" %i ", 11);
	test(" %i ", 99);
	test(" %i ", 100);
	test(" %i ", 101);
	test(" %i ", -9);
	test(" %i ", -10);
	test(" %i ", -11);
	test(" %i ", -100);
	test(" %i ", int.MAX);
	test(" %i ", int.MIN);
	test(" %i ", 0x80000000);
	test(" %i ", long.MAX);
	test(" %i ", long.MIN);
	test(" %i ", uint.MAX);
	test("%isadfsadf%d", -1, 34);
	test("\tadswfdsf%ifdf%ddfdfsf", 0, 0xfa1afe1);
	test(" %i %i %i %i %i %i %i", int.MAX, int.MIN, long.MAX, long.MIN, ulong.MAX, 0, -42);
}

private void test_u () {
	test(" %u ", 0);
	test(" %u ", 1);
	test(" %u ", -1);
	test(" %u ", 9);
	test(" %u ", 10);
	test(" %u ", 11);
	test(" %u ", 99);
	test(" %u ", 100);
	test(" %u ", 101);
	test(" %u ", -9);
	test(" %u ", -100);
	test(" %u ", int.MAX);
	test(" %u ", int.MIN);
	test(" %u ", uint.MAX);
	test(" %u ", 2222222222);
	test(" %u ", long.MAX);
	test(" %u ", long.MIN);
	test(" %u ", 122342342423);
	test("%uuuuu%uuuuuuuujjsdf%ufsdf\n", 2222222222, 1, -4545);
	test(" %u %u %u %u %u %u %u", int.MAX, int.MIN, long.MAX, long.MIN, ulong.MAX, 0, -42);
}

private void test_x () {
	test(" %x ", 0);
	test(" %x ", -1);
	test(" %x ", 1);
	test(" %x ", 9);
	test(" %x ", 10);
	test(" %x ", 11);
	test(" %x ", 15);
	test(" %x ", 16);
	test(" %x ", 17);
	test(" %x ", 99);
	test(" %x ", 100);
	test(" %x ", 101);
	test(" %x ", -9);
	test(" %x ", -100);
	test(" %x ", int.MAX);
	test(" %x ", int.MIN);
	test(" %x ", uint.MAX);
	test(" %x ", long.MAX);
	test(" %x ", long.MIN);
	test(" %x ", 0xfa1afe);
	test("%x%x", 128998, 0);
	test(" %x %x %x %x %x %x %x", int.MAX, int.MIN, long.MAX, long.MIN, ulong.MAX, 0, -42);
}

private void test_upper_x () {
	test(" %X ", 0);
	test(" %X ", -1);
	test(" %X ", 1);
	test(" %X ", 9);
	test(" %X ", 10);
	test(" %X ", 11);
	test(" %X ", 15);
	test(" %X ", 16);
	test(" %X ", 17);
	test(" %X ", 99);
	test(" %X ", 100);
	test(" %X ", 101);
	test(" %X ", -9);
	test(" %X ", -100);
	test(" %X ", int.MAX);
	test(" %X ", int.MIN);
	test(" %X ", uint.MAX);
	test(" %X ", long.MAX);
	test(" %X ", long.MIN);
	test(" %X ", 0xbafefe);
	test("%x  %X ", 0xba, 0xef);
	test(" %X %X %X %X %X %X %X", int.MAX, int.MIN, long.MAX, long.MIN, ulong.MAX, 0, -42);
}

private void test_mix () {
	int local = 0;

	test("%%%c%%%s%%%d%%%i%%%u%%%x%%%X%%%% %%%c%%%s%%%d%%%i%%%u%%%x%%%X%%%% %%%c%%%s%%%d%%%i%%%u%%%x%%%X%%%% %c%%",
		'A', "42", 42, 42, 42, 42, 42,
		'B', "-42", -42, -42, -42, -42, 42,
		'C', "0", 0, 0, 0, 0, 42, 0);
	test("%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d",
		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
		21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37);
	test("%c %s %p %d %i %u %x %X %%", 'z', "str", &local, -42, 42, -42, 255, 255);
	test("asdfasdf%%%%pdf%pdfsf%d ddfsdfsdfd%isadf%c\n", &local, 7, 345, 0);
	test("____%%%XxXXsdfs%x", 3, 3);
	test("%s|%c|%d|%s|%c", (string?)null, 0, int.MIN, "", 'x');
	test("%d%s%d%s%d", 1, "a", 2, "b", 3);
	test("%c%c%c", 0, 'a', 0);
	test(" %c %s %c ", 0, "after nul", 0);

	// paulo-santana
	test("%c %s - %p - %d - %i %u - %x - %X %%", '\0', (string?)null, (void*)0xdeadc0de, 0, int.MIN, -1, -1, 200000000);
	test("%c - %s - %p %d - %i - %u - %x %X %%", '\0', "test", (void*)(-1), 20, -20, -1, -1, 200000000);
	test("%c - %s - %p %d - %i - %u - %x %X %%", 'a', "test", (void*)0xdeadc0de, 20, -20, -1, -1, 200000000);
	test("%c - %s - %p %d - %i - %u - %x %X %%", 'b', (string?)null, null, 20, -20, -1, -1, 200000000);
	test("%c - %s - %p %d - %i - %u - %x %X %%", 'c', "", (void*)(-1), 20, -20, -1, -1, 200000000);
	test("%i - %s - %p %d - %c - %u - %x %X %%", 20, "", (void*)(-1), '\0', -20, -1, -1, 200000000);

	// cacharle (pft, moulitest)
	test("%s %d %p %% %x", "bonjour", 42, &local, 42);
	test("%s%p%d%d%p%s%p%p%s", "a", &local, 1, 2, &very_static, "b", &local, &very_static, "c");
	test("s: %s, p: %p, d:%d", "astring", &very_static, 42);

	// every conversion with its limits
	test("%c|%s|%p|%d|%i|%u|%x|%X|%%", 0, (string?)null, null, int.MIN, int.MIN, uint.MAX, uint.MAX, uint.MAX);
	test("%c|%s|%p|%d|%i|%u|%x|%X|%%", 255, "", (void*)ulong.MAX, int.MAX, int.MAX, 0, 0, 0);
	test("%%|%X|%x|%u|%i|%d|%p|%s|%c", -1, -1, -1, -1, -1, (void*)(-1), "reverse", 'r');
	test("%d%d%d%i%i%i%u%u%u%x%x%x%X%X%X", 0, -1, 1, 0, -1, 1, 0, -1, 1, 0, -1, 1, 0, -1, 1);
	test("%s%s%s%c%c%c%p%p%p", "", (string?)null, "x", 0, 'y', 0, null, &local, null);
	test("%c%s%p%d%i%u%x%X%%%c%s%p%d%i%u%x%X%%", 'a', "b", null, 1, 2, 3, 4, 5, 'z', "y", &local, -1, -2, -3, -4, -5);

	// conversions inside sentences
	test("The %s is %d years old and has %u%% of %c", "tester", 42, 100, 'X');
	test("Address %p holds %d (hex %x / %X)", &local, 255, 255, 255);
	test("[%s] [%d] [%c] [%x] [%p]", "brackets", -42, '!', 0xabc, null);
	test("%s\n%d\n%c\n%u\n%x\n%X\n%p\n%%\n", "lines", 1, 'c', 2, 3, 4, &local);
	test("\t%s\t%d\t%c\t", "tabs", -7, '\t');
	test("end with conversion %s%d%c", "x", 9, '!');
	test("%d%%%d%%%d%%", 10, 20, 30);
}
