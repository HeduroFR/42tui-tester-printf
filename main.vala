
public extern int fake_ft_printf (string fmt, void* list);
[CCode (cname = "vprintf")]
public extern int real_ft_printf (string fmt, void* list);

void test_impl(string txt, string format, ...) {
	var lst1 = va_list();
	var lst2 = va_list.copy(lst1);
	var lst3 = va_list.copy (lst1);   // copie réservée à l'affichage
	void* ptr1 = (void*)lst1;
	void* ptr2 = (void*)lst2;
	
	int ret1 = 0;
	int ret2 = 0;
	var res_you = SupraTest.complex (2, () => {
		ret1 = fake_ft_printf (format, ptr1);
		return true;
	});

	var res_real = SupraTest.complex (1, () => {
		ret2 = real_ft_printf (format, ptr2);
		return true;
	});

	// test int return
	bool b = true;
	var sb = new StringBuilder();
	if (ret1 != ret2) {
		sb.append_printf("\t return value You: %d, Me: %d; ", ret1, ret2);
		b = false;
	}

	if (res_you.stdout != res_real.stdout) {
		sb.append_printf("\t output differs: You: \033[35m%s\033[0m, Me: \033[36m%s\033[0m; ", res_you.stdout, res_real.stdout);
		b = false;
	}

	if (b == false) {
		print("%s\n", res_you.msg_ko(sb.str));
	}
	else {
		print("%s test(%s)\n",  res_you.msg(), txt);
	}

}

[CCode (cname = "TEST", cheader_filename = "test.h", sentinel = "")]
public extern void test(string format, ...);

public void describe(string txt) {
	print("%s", txt);
}

void main()
{

	describe("\n%c basic");

	test("%c", 'a');
	test("%c%c%c*", '\0', '1', 1);
	test("%c small string", 'a');
	test("%c small string", '\0');
	test("the char is: %c", 'a');
	test("the char is: %c", '\0');
	test("n%cs", 'a');
	test("%c%c%c%c%c", 'a', 'i', 'u', 'e', 'o');
	test("l%cl%cl%cl%cl%c", 'a', 'i', 'u', 'e', 'o');
	test("l%cl%cl%cl%cl%c", '\0', '\0', '\0', 'e', '\0');

	describe("\n%s basic");

	test("%s", "");
	test("this is a %s", "test");
	test("this is 1 %s with %s %s", "test", "multiple", "strings");
	test("%s%s%s%s", "This ", "is", " an ugly ", "test");
	test("%s", "This is a rather simple test.");
	test("%s", "-2");
	test("%s", "-24");
	test("%s", "-stop");
	test("%s", "-0003");
	test("%s", "000-0003");
	test("%s", "0x42");
	test("%s", "0x0000042");
	test("some naugty tests: %s", "0000%");
	test("some naugty tests: %s", "    %");
	test("some naugty tests: %s", "%000");
	test("%s", "bea thought but bea forgot the loop that the chars cause she was floaty during the amsterdam siren call. she got me by surprise you probably read my mind that look in your eyes and judging by your own cries you probably read my mind this is a really long string and if you see this you must look at your return values!kthxbai this must have more than 127 chars by now isnt it ok 4242 4 life 1337 code everyday to the moon!");
	test("%s", null_str);
	test("%s everywhere", null_str);
	test("everywhere %s", null_str);
	test("%s", "h");
	test("t%st%s", "a", "u");
	test("%s%s%s%s%s%s", "a", "i", "u", "e", "o", "l");

	describe("\n%p basic");

	int test = 42;
	test("%p", &test);
	test("%p is a virtual memory address", &test);
	test("The address of the answer is %p", &test);
	test("The address is %p, so what?", &test);
	int *ptr = &test;
	// test("A pointer at %p points to %p", &test, &ptr);
	// test("This %p is a very strange address", (void *)(long int)test);

	char *mallocked = malloc(2);
	// test("This %p is an address from the heap", mallocked); free(mallocked);); free(mallocked);
	// test("%p", NULL);
	// test("The NULL macro represents the %p address", NULL);
	// test("This %p is even stranger", (void *)-1);

	right_cat = test_cat ? test_cat & (CAT_D | CAT_MANDATORY) : 1;
	describe("\n%d basic");

	test("%d", 0);
	test("%d", 10);
	test("%d, %d", 10, 20);
	test("%d%d%d%d", 10, 20, 30, 5);
	test("%d %d", 2147483647, (int)-2147483648);
	test("42 - 84 is %d", -42);
	test("%d C is the lowest temperature in the universe", -273);
	test("%dxC is the lowest temperature in the universe", -273);
	test("%dsC is the lowest temperature in the universe", -273);
	test("%dpC is the lowest temperature in the universe", -273);

	right_cat = test_cat ? test_cat & (CAT_I | CAT_MANDATORY) : 1;
	describe("\n%i basic");

	test("%i", 0);
	test("%i", 10);
	test("%i, %i", 10, 23);
	test("%i%i%i%i%i%i%i", 10, 23, -2, 37, 200, -9999, 977779);
	test("%i %i", 2147483647, (int)-2147483648);
	test("%iq%i", 21447, -21648);

	right_cat = test_cat ? test_cat & (CAT_U | CAT_MANDATORY) : 1;
	describe("\n%u basic");

	test("%u", 42);
	test("%u", 0);
	test("%u", 2147483647);
	test("%u", (uint)2147483648);
	test("%u", (uint)3147983649);
	test("%u", (uint)4294967295);
	test("%u to the power of %u is %u", 2, 32, (uint)4294967295);
	test("%u%u%u%u", (uint)429896724, 0, 32, (uint)4294967295);

	right_cat = test_cat ? test_cat & (CAT_X | CAT_MANDATORY ) : 1;
	describe("\n%x basic");

	test("%x", 0);
	test("%x", 1);
	test("%x", 10);
	test("%x", 16);
	test("%x", 160);
	test("%x", 255);
	test("%x", 256);
	test("%x", 3735929054u);
	test("the password is %x", 3735929054u);
	test("%x is the definitive answer", 66u);
	test("this is the real number: %x", -1u);

	right_cat = test_cat ? test_cat & (CAT_BIG_X | CAT_MANDATORY ): 1;
	describe("\n%X basic");

	test("%X", 0);
	test("%X", 1);
	test("%X", 10);
	test("%X", 16);
	test("%X", 160);
	test("%X", 255);
	test("%X", 256);
	test("%X", (uint)3735929054);
	test("the password is %X", (uint)3735929054);
	test("%X is the definitive answer", (uint)66);
	test("this is the real number: %X", (uint)-1);

	right_cat = test_cat ? test_cat & (CAT_PERCENT | CAT_MANDATORY) : 1;
	describe("\n%% basic");

	test("%%");
	test("100%%");
	test("%%p is how you print a pointer in printf");
	test("the '%%%%' is used to print a %% in printf");
	test("%%%%%%%%%%%%%%%%");
	test("%%c%%s%%p%%d%%i%%u%%x%%X%%");

	right_cat = test_cat ? test_cat & CAT_MANDATORY : 1;
	describe("\nmix");

	test("%c - %s - %p %d - %i - %u - %x %X %%", 'a', "test", (size_t)0xdeadc0de, 20, -20, -1, -1, 200000000);
	test("%c - %s - %p %d - %i - %u - %x %X %%", '\0', "test", (size_t)-1, 20, -20, -1, -1, 200000000);
	test("%c - %s - %p %d - %i - %u - %x %X %%", 'c', "", (size_t)-1, 20, -20, -1, -1, 200000000);
	test("%i - %s - %p %d - %c - %u - %x %X %%", 20, "", (size_t)-1, '\0', -20, -1, -1, 200000000);
	test("%c - %s - %p %d - %i - %u - %x %X %%", 'b', null_str, NULL, 20, -20, -1, -1, 200000000);
	test("%c %s - %p - %d - %i %u - %x - %X %%", '\0', null_str, (void *)0xdeadc0de, 0, (int)-2147483648, -1, -1, 200000000);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
		: test_cat ? (test_cat & CAT_C && test_cat & CAT_BONUS_1)
		: 1;
	describe("\n%c and widths");

	test("%1c", 'a');
	test("%1c", '\0');
	test("%10c", 'b');
	test("%10c", '\0');
	test("%2c", 'c');
	test("there are 15 spaces between this text and the next char%15c", 'd');
	test("%5chis paragraph is indented", 't');
	test("%5c now you see", '\0');
	test("The number %7c represents luck", '7');

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
		: test_cat ? (test_cat & CAT_S && test_cat & CAT_BONUS_1)
		: 1;
	describe("\n%s and widths");

	test("%1s", "a");
	test("%1s", "abc");
	test("%7s", "a");
	test("%7s", "abc");
	test("%1s", "-42");
	test("%2s", "-42");
	test("%3s", "-42");
	test("%4s", "-42");
	test("%5s", "-42");
	test("%6s", "-42");
	test("%1s", null_str);
	test("%2s", null_str);
	test("%5s", null_str);
	test("%6s", null_str);
	test("%7s", null_str);
	test("%7s is as easy as %13s", "abc", "123");
	test("%13s are the three first letter of the %3s", "a, b and c", "alphabet");
	test("%s%13s%42s%3s", "a, b and c", " are letters", " of the", " alphabet");
	test("%sc%13sd%42sp%3sx", "a, b and c", " are letters", " of the", " alphabet");
	test("%sc%13sd%42sp%3sx", "a, b and c", " are letters", " of the", " alphabet");

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_P && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%p and widths");

	char c;
	test("%1p", &c);
	test("%30p", &c);
	test("%12p", (void *)0x7ffe6b8e60c6);
	test("%13p", (void *)0x7ffe6b8e60c5);
	test("%14p", (void *)0x7ffe6b8e60c4);
	test("the address is %12p", (void *)0x7ffe6b8e60c7);
	test("the address is %13p", (void *)0x7ffe6b8e60c8);
	test("the address is %14p", (void *)0x7ffe6b8e60c9);
	test("the address is %1p", (void *)0);
	test("the address is %2p", (void *)0);
	test("the address is %3p", (void *)0);
	test("the address is %4p", (void *)0);
	test("the address is %8p", (void *)0);
	test("%12p is the address", (void *)0x7ffe6b8e60c7);
	test("%13p is the address", (void *)0x7ffe6b8e60c8);
	test("%14p is the address", (void *)0x7ffe6b8e60c9);
	test("%1p is the address", (void *)0);
	test("%2p is the address", (void *)0);
	test("%3p is the address", (void *)0);
	test("%4p is the address", (void *)0);
	test("%8p is the address", (void *)0);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_D && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%d and widths");

	test("%1d", 0);
	test("%1d", -4);
	test("%10d", 42);
	test("%42d", 42000);
	test("%20d", -42000);
	test("wait for it... %50d", 42);
	test("%20d is how many tests are going to be made", 8000);
	test("%5d", 2147483647);
	test("%30d", 2147483647);
	test("%10d", 2147483647);
	test("%5d", (int)-2147483648);
	test("%30d", (int)-2147483648);
	test("%10d", (int)-2147483648);
	test("%11d", (int)-2147483648);
	test("%12d", (int)-2147483648);
	test("%12d, %20d, %2d, %42d", (int)-2147483648, 3, 30, -1);
	test("%12d, %d, %2d, %42d", (int)-2147483648, 3, 30, -1);
	test("%14d%20d%2d%d", (int)-2147483648, 3, 30, -1);
	test("%14dc%20ds%2dx%du", (int)-2147483648, 3, 30, -1);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_I && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%i and widths");

	test("%1i", 0);
	test("%1i", -4);
	test("%10i", 42);
	test("%42i", 42000);
	test("%20i", -42000);
	test("wait for it... %50i", 42);
	test("%20i is how many tests are going to be made", 8000);
	test("%5i", 2147483647);
	test("%30i", 2147483647);
	test("%10i", 2147483647);
	test("%5i", (int)-2147483648);
	test("%30i", (int)-2147483648);
	test("%10i", (int)-2147483648);
	test("%11i", (int)-2147483648);
	test("%12i", (int)-2147483648);
	test("%12i, %20i, %2i, %42i", (int)-2147483648, 3, 30, -1);
	test("%12i, %i, %2i, %42i", (int)-2147483648, 3, 30, -1);
	test("%14i%20i%2i%i", (int)-2147483648, 3, 30, -1);
	test("%14ic%20is%2ix%du", (int)-2147483648, 3, 30, -1);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_U && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%u and widths");

	test("%1u", 0);
	test("%2u", 1);
	test("%1u", 1000);
	test("%4u", 1000);
	test("%30u", 1000);
	test("%9u is the biggest uint", (uint)-1);
	test("%10uis the biggest uint", (uint)-1);
	test("%11uis the biggest uint", (uint)-1);
	test("the biggest uint is %9u", (uint)-1);
	test("the biggest uint is %10u", (uint)-1);
	test("the biggest uint is %11u", (uint)-1);
	test("Here are some numbers: %1u%2u%5u%3u%9u and %ui", 11, (uint)-1, 2, 200, 3, 10);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_X && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%x and widths");

	test("%1x", 0);
	test("%2x", 1);
	test("%3x", 10);
	test("%1x", 16);
	test("%2x", 160);
	test("%3x", 255);
	test("%42x", 256);
	test("%7x", (uint)3735929054);
	test("%8x", (uint)3735929054);
	test("%9x", (uint)3735929054);
	test("the password is %7x", (uint)3735929054);
	test("the password is %8x", (uint)3735929054);
	test("the password is %9x", (uint)3735929054);
	test("%1x is the definitive answer", (uint)66);
	test("%2x is the definitive answer", (uint)66);
	test("%3x is the definitive answer", (uint)66);
	test("this is the real number: %7x", (uint)-1);
	test("this is the real number: %8x", (uint)-1);
	test("this is the real number: %9x", (uint)-1);
	test("%1x%2x%9x", (uint)-1, 0xf0ca, 123456);
	test("%1xis doomed%2xpost%9xX args", (uint)-1, 0xf0b1a, 7654321);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_BIG_X && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%X and widths");

	test("%1X", 0);
	test("%2X", 1);
	test("%3X", 10);
	test("%1X", 16);
	test("%2X", 160);
	test("%3X", 255);
	test("%42X", 256);
	test("%7X", (uint)3735929054);
	test("%8X", (uint)3735929054);
	test("%9X", (uint)3735929054);
	test("the password is %7X", (uint)3735929054);
	test("the password is %8X", (uint)3735929054);
	test("the password is %9X", (uint)3735929054);
	test("%1X is the definitive answer", (uint)66);
	test("%2X is the definitive answer", (uint)66);
	test("%3X is the definitive answer", (uint)66);
	test("this is the real number: %7X", (uint)-1);
	test("this is the real number: %8X", (uint)-1);
	test("this is the real number: %9X", (uint)-1);
	test("%1X%2X%9X", (uint)-1, 0xf0ca, 123456);
	test("%1Xis doomed%2Xpost%9Xx args", (uint)-1, 0xf0b1a, 7654321);

	describe("\n%s and precisions");

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_S && test_cat & CAT_BONUS_1)
			: 1;
	test("%.s", "hi there");
	test("%.0s", "hi there");
	test("%.1s", "hi there");
	test("%.2s", "hi there");
	test("%.3s", "hi there");
	test("%.4s", "hi there");
	test("%.7s", "hi there");
	test("%.8s", "hi there");
	test("%.9s", "hi there");
	test("%.12s", "hi there");
	test("%.s", "-42");
	test("%.0s", "-42");
	test("%.1s", "-42");
	test("%.2s", "-42");
	test("%.3s", "-42");
	test("%.4s", "-42");
	test("%.7s", "-42");
	test("%.1s", null_str);
	test("%.2s", null_str);
	test("%.5s", null_str);
	test("%.6s", null_str);
	test("%.7s", null_str);
	test("%.2s, motherfucker", "hi there");
	test("This %.3s a triumph ", "wasabi");
	test("%.4s making a %.4s here: %.13s", "I'm delighted", "notation", "HUGE SUCCESS!");
	test("It's %.4s to over%.50s my%s", "hardware", "state", " satisfaction");
	test("%.11s%.6s%.4s", "Aperture", " Scientists", "ce");
	test("%1.s", "21-school.ru"); //Rustem (bnidia)
	test("%10.1s", "21-school.ru"); //Rustem (bnidia)

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_D && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%d and precisions");

	test("%.1d", 2);
	test("%.2d", 3);
	test("%.4d", 32);
	test("%.3d", 420000);
	test("%.0d", 420000);
	test("%.3d", -1);
	test("%.3d", -1234);
	test("%.4d", -1234);
	test("%.5d", -1234);
	test("%.5d", (int)-2147483648);
	test("%.9d", (int)-2147483648);
	test("%.10d", (int)-2147483648);
	test("%.11d", (int)-2147483648);
	test("%.12d", (int)-2147483648);
	test("%.13d", (int)-2147483648);
	test("%.5d", 2147483647);
	test("%.9d", 2147483647);
	test("%.10d", 2147483647);
	test("%.11d", 2147483647);
	test("%.12d", 2147483647);
	test("%.0d", 2);
	test("%.0d", 2147483647);
	test("%.0d", 0);
	test("%.0d", 10);
	test("%.d", 10);
	test("%.d", 0);
	test("I'm gonna watch %.3d", 7);
	test("%.3d is the movie I'm gonna watch", 7);
	test("Then take these %.7d things and get the hell out of here", 2);
	test("Bla %.2di bla %.5dsbla bla %.dx bla %.d", 127, 42, 1023, 0);
	test("%.4d%.2d%.20d%.0d%.0d%.d%.d%.d", 127, 0, 1023, 0, (int)-2147483648, 0, 1, (int)-2147483648);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
		: test_cat ? (test_cat & CAT_I && test_cat & CAT_BONUS_1)
		: 1;
	describe("\n%i and precisions");

	test("%.1i", 7);
	test("%.3i", 7);
	test("%.2i", 3);
	test("%.4i", 32);
	test("%.3i", 420000);
	test("%.0i", 420000);
	test("%.3i", -1);
	test("%.3i", -1234);
	test("%.4i", -1234);
	test("%.5i", -1234);
	test("%.5i", (int)-2147483648);
	test("%.9i", (int)-2147483648);
	test("%.10i", (int)-2147483648);
	test("%.11i", (int)-2147483648);
	test("%.12i", (int)-2147483648);
	test("%.13i", (int)-2147483648);
	test("%.5i", 2147483647);
	test("%.9i", 2147483647);
	test("%.10i", 2147483647);
	test("%.11i", 2147483647);
	test("%.12i", 2147483647);
	test("%.0i", 2);
	test("%.0i", 2147483647);
	test("%.0i", 0);
	test("%.0i", 10);
	test("%.i", 10);
	test("%.i", 0);
	test("I'm gonna watch %.3i", 7);
	test("%.3i is the movie I'm gonna watch", 7);
	test("Then take these %.7i things and get the hell out of here", 2);
	test("Bla %.2ii bla %.5isbla bla %.ix bla %.i", 127, 42, 1023, 0);
	test("%.4i%.2i%.20i%.0i%.0i%.i%.i%.i", 127, 0, 1023, 0, (int)-2147483648, 0, 1, (int)-2147483648);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
		: test_cat ? (test_cat & CAT_U && test_cat & CAT_BONUS_1)
		: 1;
	describe("\n%u and precisions");

	test("%.1u", 1);
	test("%.2u", 1);
	test("%.2u", 0);
	test("%.0u", 0);
	test("%.u", 0);
	test("%.2u", 30000);
	test("%.20u", 30000);
	test("%.0u", (uint)-1);
	test("%.5u", (uint)-1);
	test("%.9u", (uint)-1);
	test("%.10u", (uint)-1);
	test("%.11u", (uint)-1);
	test("%.10uis a big number", (uint)-1);
	test("%.0uis a big number", (uint)-1);
	test("%.4us a big number", (uint)-1);
	test("%.9uxs a big number", (uint)-1);
	test("%.11ups a big number", (uint)-1);
	test("the number is %.0u", (uint)-1);
	test("the number is %.u", (uint)-1);
	test("the number is %.5u", (uint)-1);
	test("the number is %.9u", (uint)-1);
	test("the number is %.10u", (uint)-1);
	test("the number is %.11u", (uint)-1);
	test("the number is %.11u", (uint)-1);
	test("%.0uis a big number", 0);
	test("%.4us a big number", 0);
	test("the number is %.0u", 0);
	test("the number is %.u", 0);
	test("the number is %.5u", 0);
	test("%u%.5u%.0u%.u%.9u", 5, 55, 2, 0, 42);
	test("%us%.5ui%.0uc%.up%.9ux", 5, 55, 2, 0, 42);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
		: test_cat ? (test_cat & CAT_X && test_cat & CAT_BONUS_1)
		: 1;
	describe("\n%x and precisions");

	test("%.1x", 0xa);
	test("%.4x", 11);
	test("%.0x", 0);
	test("%.1x", -1);
	test("%.10x", -1);
	test("%.14x", -1);
	test("%.8x", 0);
	test("%.2x", 30000);
	test("%.20x", 30000);
	test("%.0x", (uint)-1);
	test("%.5x", (uint)-1);
	test("%.9x", (uint)-1);
	test("%.10x", (uint)-1);
	test("%.11x", (uint)-1);
	test("%.10xis a big number", (uint)-1);
	test("%.0xis a big number", (uint)-1);
	test("%.4xs a big number", (uint)-1);
	test("%.9xxs a big number", (uint)-1);
	test("%.11xps a big number", (uint)-1);
	test("the number is %.0x", (uint)-1);
	test("the number is %.x", (uint)-1);
	test("the number is %.5x", (uint)-1);
	test("the number is %.9x", (uint)-1);
	test("the number is %.10x", (uint)-1);
	test("the number is %.11x", (uint)-1);
	test("the number is %.11x", (uint)-1);
	test("%.0xis a big number", 0);
	test("%.4xs a big number", 0);
	test("the number is %.0x", 0);
	test("the number is %.x", 0);
	test("the number is %.5x", 0);
	test("%x%.5x%.0x%.x%.9x", 5, 55, 2, 0, 42);
	test("%xs%.5xi%.0xc%.xp%.9xu", 5, 55, 2, 0, 42);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
		: test_cat ? (test_cat & CAT_BIG_X && test_cat & CAT_BONUS_1)
		: 1;
	describe("\n%X and precisions");

	test("%.1X", 0xa);
	test("%.4X", 11);
	test("%.0X", 0);
	test("%.1X", -1);
	test("%.10X", -1);
	test("%.14X", -1);
	test("%.8X", 0);
	test("%.2X", 30000);
	test("%.20X", 30000);
	test("%.0X", (uint)-1);
	test("%.5X", (uint)-1);
	test("%.9X", (uint)-1);
	test("%.10X", (uint)-1);
	test("%.11X", (uint)-1);
	test("%.10Xis a big number", (uint)-1);
	test("%.0Xis a big number", (uint)-1);
	test("%.4Xs a big number", (uint)-1);
	test("%.9XXs a big number", (uint)-1);
	test("%.11Xps a big number", (uint)-1);
	test("the number is %.0X", (uint)-1);
	test("the number is %.X", (uint)-1);
	test("the number is %.5X", (uint)-1);
	test("the number is %.9X", (uint)-1);
	test("the number is %.10X", (uint)-1);
	test("the number is %.11X", (uint)-1);
	test("the number is %.11X", (uint)-1);
	test("%.0Xis a big number", 0);
	test("%.4Xs a big number", 0);
	test("the number is %.0X", 0);
	test("the number is %.X", 0);
	test("the number is %.5X", 0);
	test("%X%.5X%.0X%.X%.9X", 5, 55, 2, 0, 42);
	test("%Xs%.5Xi%.0Xc%.Xp%.9Xu", 5, 55, 2, 0, 42);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
		: test_cat ? (test_cat & CAT_C && test_cat & CAT_BONUS_1)
		: 1;
	describe("\n%c, widths and -");

	// this is literally a negative width '-'
	test("%-c", 'p');
	test("%-1c", 'b');
	test("%-5c", 'w');
	test(" kk daora%-5cblz", 'w');
	test("%-20carigatou", 'w');
	test("%-c%-c%-4c%-11c", 'a', 'b', 'c', 'd');
	test("%-ci%-cp%4cs%-11cx", 'a', 'b', 'c', 'd');
	test("%----ci%---cp%4cs%--11cx", 'a', 'b', 'c', 'd');
	test("%-c%-c%c*", 0, '1', 1);
	test("%-2c%-3c%-4c*", 0, 'a', 0);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_S && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%s, widths, precisions and -");

	test("%-9sScience!", "Aperture");
	test("We %-s what we %8s, %-2s we %-20s", "do", "must", "because", "can");
	test("%--4s %s %------------------9s of %s of %-5s", "for", "the", "goooood", "aaall", "us");
	test("%--4.1s %s %------------------9.3s of %s of %-5.7s", "for", "the", "goooood", "aaall", "us");
	test("%--.sp--.su kkkk", "pegadinha po");
	test("%-9sScience!", "-42");

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_P && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%p, widths and -");

	test("that's the way it %-20pis", "");
	test("%------21p yeah i'm %p running out %--p of ideas", (void *) 13, (void *) 65, (void *) -1);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_D && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%d, widths, precisions and -");

	test("%-d", 0);
	test("%-d", 1);
	test("%-d", 10);
	test("%-d", -10);
	test("%-d", 5000);
	test("%-d", -5000);
	test("%-d", (int)-2147483648);
	test("%-d", 2147483647);
	test("%-1d", 0);
	test("%-1d", 1);
	test("%-1d", 10);
	test("%-1d", -10);
	test("%-1d", 5000);
	test("%-1d", -5000);
	test("%-1d", (int)-2147483648);
	test("%-1d", 2147483647);
	test("%-10d", 0);
	test("%-10d", 1);
	test("%-10d", 10);
	test("%-10d", -10);
	test("%-10d", 5000);
	test("%-10d", -5000);
	test("%-10d", (int)-2147483648);
	test("%-10d", 2147483647);
	test("%-.d", 0);
	test("%-.1d", 1);
	test("%-.2d", 10);
	test("%-.3d", -10);
	test("%-.4d", 5000);
	test("%-.5d", -5000);
	test("%-.6d", (int)-2147483648);
	test("%-.7d", 2147483647);
	test("%-1.8d", 0);
	test("%-1.9d", 1);
	test("%-1.10d", 10);
	test("%-1.0d", -10);
	test("%-1.6d", 5000);
	test("%-1.4d", -5000);
	test("%-1.10d", (int)-2147483648);
	test("%-1.12d", 2147483647);
	test("%-10.d", 0);
	test("%-10.10d", 1);
	test("%-10.5d", 10);
	test("%-10.2d", -10);
	test("%-10.5d", 5000);
	test("%-10.5d", -5000);
	test("%-10.15d", (int)-2147483648);
	test("%-10.5d", 2147483647);
	test("%-15.d", 0);
	test("%-15.10d", 1);
	test("%-15.5d", 10);
	test("%-15.2d", -10);
	test("%-15.5d", 5000);
	test("%-15.5d", -5000);
	test("%-15.15d", (int)-2147483648);
	test("%-15.5d", 2147483647);
	test("%-4.5d%d%4d%-10d-d5%-.3d", 3, 4, 5, 6, 7);
	test("%-4.5d%d%4d%-10d-d5%-.3d", 300000, 400000, 500000, 600000, 700000);
	test("%-4.5d%d%4d%-10d-d5%-.3d", -300000, -400000, -500000, -600000, -700000);
	test("%-4.5d%d%4d%-10d-d5%-.3d", 2147483647, 2141483647, 2141483647, 2141483647, 2141483647);
	test("%-4.5d%d%4d%-10d-d5%-.3d", (int)-2147483648, (int)-2141483648, (int)-2141483648, (int)-2141483648, (int)-2141483648);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_I && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%i, widths, precisions and -");

	test("%-i", 0);
	test("%-i", 1);
	test("%-i", 10);
	test("%-i", -10);
	test("%-i", 5000);
	test("%-i", -5000);
	test("%-i", (int)-2147483648);
	test("%-i", 2147483647);
	test("%-1i", 0);
	test("%-1i", 1);
	test("%-1i", 10);
	test("%-1i", -10);
	test("%-1i", 5000);
	test("%-1i", -5000);
	test("%-1i", (int)-2147483648);
	test("%-1i", 2147483647);
	test("%-10i", 0);
	test("%-10i", 1);
	test("%-10i", 10);
	test("%-10i", -10);
	test("%-10i", 5000);
	test("%-10i", -5000);
	test("%-10i", (int)-2147483648);
	test("%-10i", 2147483647);
	test("%-.i", 0);
	test("%-.1i", 1);
	test("%-.2i", 10);
	test("%-.3i", -10);
	test("%-.4i", 5000);
	test("%-.5i", -5000);
	test("%-.6i", (int)-2147483648);
	test("%-.7i", 2147483647);
	test("%-1.8i", 0);
	test("%-1.9i", 1);
	test("%-1.10i", 10);
	test("%-1.0i", -10);
	test("%-1.6i", 5000);
	test("%-1.4i", -5000);
	test("%-1.10i", (int)-2147483648);
	test("%-1.12i", 2147483647);
	test("%-10.i", 0);
	test("%-10.10i", 1);
	test("%-10.5i", 10);
	test("%-10.2i", -10);
	test("%-10.5i", 5000);
	test("%-10.5i", -5000);
	test("%-10.15i", (int)-2147483648);
	test("%-10.5i", 2147483647);
	test("%-15.i", 0);
	test("%-15.10i", 1);
	test("%-15.5i", 10);
	test("%-15.2i", -10);
	test("%-15.5i", 5000);
	test("%-15.5i", -5000);
	test("%-15.15i", (int)-2147483648);
	test("%-15.5i", 2147483647);
	test("%-4.5i%i%4i%-10i-i5%-.3i", 3, 4, 5, 6, 7);
	test("%-4.5i%i%4i%-10i-i5%-.3i", 300000, 400000, 500000, 600000, 700000);
	test("%-4.5i%i%4i%-10i-i5%-.3i", -300000, -400000, -500000, -600000, -700000);
	test("%-4.5i%i%4i%-10i-i5%-.3i", 2147483647, 2141483647, 2141483647, 2141483647, 2141483647);
	test("%-4.5i%i%4i%-10i-i5%-.3i", (int)-2147483648, (int)-2141483648, (int)-2141483648, (int)-2141483648, (int)-2141483648);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_U && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%u, widths, precisions and -");

	test("%-u", 0);
	test("%-u", 1);
	test("%-u", 10);
	test("%-u", -10);
	test("%-u", 5000);
	test("%-u", -5000);
	test("%-u", (uint)-1);
	test("%-u", 2147483647);
	test("%-1u", 0);
	test("%-1u", 1);
	test("%-1u", 10);
	test("%-1u", -10);
	test("%-1u", 5000);
	test("%-1u", -5000);
	test("%-1u", (uint)-1);
	test("%-1u", 2147483647);
	test("%-10u", 0);
	test("%-10u", 1);
	test("%-10u", 10);
	test("%-10u", -10);
	test("%-10u", 5000);
	test("%-10u", -5000);
	test("%-10u", -1);
	test("%-10u", 2147483647);
	test("%-.u", 0);
	test("%-.1u", 1);
	test("%-.2u", 10);
	test("%-.3u", -10);
	test("%-.4u", 5000);
	test("%-.5u", -5000);
	test("%-.6u", -1);
	test("%-.7u", 2147483647);
	test("%-1.8u", 0);
	test("%-1.9u", 1);
	test("%-1.10u", 10);
	test("%-1.0u", -10);
	test("%-1.6u", 5000);
	test("%-1.4u", -5000);
	test("%-1.10u", -1);
	test("%-1.12u", 2147483647);
	test("%-10.u", 0);
	test("%-10.10u", 1);
	test("%-10.5u", 10);
	test("%-10.2u", -10);
	test("%-10.5u", 5000);
	test("%-10.5u", -5000);
	test("%-10.15u", -1);
	test("%-10.5u", 2147483647);
	test("%-15.u", 0);
	test("%-15.10u", 1);
	test("%-15.5u", 10);
	test("%-15.2u", -10);
	test("%-15.5u", 5000);
	test("%-15.5u", -5000);
	test("%-15.15u", -1);
	test("%-15.5u", 2147483647);
	test("%-4.5u%u%4u%-10u-u5%-.3u", 3, 4, 5, 6, 7);
	test("%-4.5u%u%4u%-10u-u5%-.3u", 300000, 400000, 500000, 600000, 700000);
	test("%-4.5u%u%4u%-10u-u5%-.3u", -300000, -400000, -500000, -600000, -700000);
	test("%-4.5u%u%4u%-10u-u5%-.3u", 2147483647, 2141483647, 2141483647, 2141483647, 2141483647);
	test("%-4.5u%u%4u%-10u-u5%-.3u", -1, -1, -1, -1, -1);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_X && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%x, widths, precisions and -");

	test("%-x", 0);
	test("%-x", 1);
	test("%-x", 10);
	test("%-x", -10);
	test("%-x", 5000);
	test("%-x", -5000);
	test("%-x", -1);
	test("%-x", 2147483647);
	test("%-1x", 0);
	test("%-1x", 1);
	test("%-1x", 10);
	test("%-1x", -10);
	test("%-1x", 5000);
	test("%-1x", -5000);
	test("%-1x", -1);
	test("%-1x", 2147483647);
	test("%-10x", 0);
	test("%-10x", 1);
	test("%-10x", 10);
	test("%-10x", -10);
	test("%-10x", 5000);
	test("%-10x", -5000);
	test("%-10x", -1);
	test("%-10x", 2147483647);
	test("%-.x", 0);
	test("%-.1x", 1);
	test("%-.2x", 10);
	test("%-.3x", -10);
	test("%-.4x", 5000);
	test("%-.5x", -5000);
	test("%-.6x", -1);
	test("%-.7x", 2147483647);
	test("%-1.8x", 0);
	test("%-1.9x", 1);
	test("%-1.10x", 10);
	test("%-1.0x", -10);
	test("%-1.6x", 5000);
	test("%-1.4x", -5000);
	test("%-1.10x", -1);
	test("%-1.12x", 2147483647);
	test("%-10.x", 0);
	test("%-10.10x", 1);
	test("%-10.5x", 10);
	test("%-10.2x", -10);
	test("%-10.5x", 5000);
	test("%-10.5x", -5000);
	test("%-10.15x", -1);
	test("%-10.5x", 2147483647);
	test("%-15.x", 0);
	test("%-15.10x", 1);
	test("%-15.5x", 10);
	test("%-15.2x", -10);
	test("%-15.5x", 5000);
	test("%-15.5x", -5000);
	test("%-15.15x", -1);
	test("%-15.5x", 2147483647);
	test("%-4.5x%x%4x%-10x-x5%-.3x", 3, 4, 5, 6, 7);
	test("%-4.5x%x%4x%-10x-x5%-.3x", 300000, 400000, 500000, 600000, 700000);
	test("%-4.5x%x%4x%-10x-x5%-.3x", -300000, -400000, -500000, -600000, -700000);
	test("%-4.5x%x%4x%-10x-x5%-.3x", 2147483647, 2141483647, 2141483647, 2141483647, 2141483647);
	test("%-4.5x%x%4x%-10x-x5%-.3x", -1, -1, -1, -1, -1);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_BIG_X && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%X, widths, precisions and -");

	test("%-X", 0);
	test("%-X", 1);
	test("%-X", 10);
	test("%-X", -10);
	test("%-X", 5000);
	test("%-X", -5000);
	test("%-X", -1);
	test("%-X", 2147483647);
	test("%-1X", 0);
	test("%-1X", 1);
	test("%-1X", 10);
	test("%-1X", -10);
	test("%-1X", 5000);
	test("%-1X", -5000);
	test("%-1X", -1);
	test("%-1X", 2147483647);
	test("%-10X", 0);
	test("%-10X", 1);
	test("%-10X", 10);
	test("%-10X", -10);
	test("%-10X", 5000);
	test("%-10X", -5000);
	test("%-10X", -1);
	test("%-10X", 2147483647);
	test("%-.X", 0);
	test("%-.1X", 1);
	test("%-.2X", 10);
	test("%-.3X", -10);
	test("%-.4X", 5000);
	test("%-.5X", -5000);
	test("%-.6X", -1);
	test("%-.7X", 2147483647);
	test("%-1.8X", 0);
	test("%-1.9X", 1);
	test("%-1.10X", 10);
	test("%-1.0X", -10);
	test("%-1.6X", 5000);
	test("%-1.4X", -5000);
	test("%-1.10X", -1);
	test("%-1.12X", 2147483647);
	test("%-10.X", 0);
	test("%-10.10X", 1);
	test("%-10.5X", 10);
	test("%-10.2X", -10);
	test("%-10.5X", 5000);
	test("%-10.5X", -5000);
	test("%-10.15X", -1);
	test("%-10.5X", 2147483647);
	test("%-15.X", 0);
	test("%-15.10X", 1);
	test("%-15.5X", 10);
	test("%-15.2X", -10);
	test("%-15.5X", 5000);
	test("%-15.5X", -5000);
	test("%-15.15X", -1);
	test("%-15.5X", 2147483647);
	test("%-4.5X%X%4X%-10X-X5%-.3X", 3, 4, 5, 6, 7);
	test("%-4.5X%X%4X%-10X-X5%-.3X", 300000, 400000, 500000, 600000, 700000);
	test("%-4.5X%X%4X%-10X-X5%-.3X", -300000, -400000, -500000, -600000, -700000);
	test("%-4.5X%X%4X%-10X-X5%-.3X", 2147483647, 2141483647, 2141483647, 2141483647, 2141483647);
	test("%-4.5X%X%4X%-10X-X5%-.3X", -1, -1, -1, -1, -1);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
		: test_cat ? (test_cat & CAT_D && test_cat & CAT_BONUS_1)
		: 1;
	describe("\n%d, widths, precisions and 0");

	test("%01d", 0);
	test("%01d", -4);
	test("%010d", 42);
	test("%042d", 42000);
	test("%020d", -42000);
	test("wait for it... %050d", 42);
	test("%020d is how many tests are going to be made", 8000);
	test("%05d", 2147483647);
	test("%030d", 2147483647);
	test("%010d", 2147483647);
	test("%05d", (int)-2147483648);
	test("%030d", (int)-2147483648);
	test("%010d", (int)-2147483648);
	test("%011d", (int)-2147483648);
	test("%012d", (int)-2147483648);
	test("%012d, %20d, %2d, %42d", (int)-2147483648, 3, 30, -1);
	test("%012d, %d, %2d, %42d", (int)-2147483648, 3, 30, -1);
	test("%014d%020d%02d%0d", (int)-2147483648, 3, 30, -1);
	test("%014dc%020ds%02dx%0du", (int)-2147483648, 3, 30, -1);
	test("%01.d", 0);
	test("%01.0d", 0);
	test("%02.0d", 0);
	test("%03.0d", 0);
	test("%01.1d", 0);
	test("%01.2d", 0);
	test("%01.3d", 0);
	test("%01.0d", -4);
	test("%01.1d", -4);
	test("%01.2d", -4);
	test("%01.3d", -4);
	test("%01.0d", 4);
	test("%01.1d", 4);
	test("%01.2d", 4);
	test("%01.3d", 4);
	test("%010.20d", 42);
	test("%042.2d", 42000);
	test("%042.20d", 42000);
	test("%042.42d", 42000);
	test("%042.52d", 42000);
	test("%020.10d", -42000);
	test("%020.20d", -42000);
	test("%020.30d", -42000);
	test("wait for it... %050.50d", 42);
	test("%020.19d is how many tests are going to be made", 8000);
	test("%020.20d is how many tests are going to be made", 8000);
	test("%020.21d is how many tests are going to be made", 8000);
	test("%05d", 2147483647);
	test("%030d", 2147483647);
	test("%09d", 2147483647);
	test("%010d", 2147483647);
	test("%011d", 2147483647);
	test("%05d", (int)-2147483648);
	test("%030d", (int)-2147483648);
	test("%010d", (int)-2147483648);
	test("%011d", (int)-2147483648);
	test("%012d", (int)-2147483648);
	test("%012d, %20d, %2d, %000042d", (int)-2147483648, 3, 30, -1);
	test("%012d, %d, %002d, %42d", (int)-2147483648, 3, 30, -1);
	test("%0014.2d%020d%0002.d%000.5d", (int)-2147483648, 3, 30, -1);
	test("%014dc%020ds%02dx%0du", (int)-2147483648, 3, 30, -1);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_I && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%i, widths, precisions and 0");

	test("%01i", 0);
	test("%01i", -4);
	test("%010i", 42);
	test("%042i", 42000);
	test("%020i", -42000);
	test("wait for it... %050i", 42);
	test("%020i is how many tests are going to be maie", 8000);
	test("%05i", 2147483647);
	test("%030i", 2147483647);
	test("%010i", 2147483647);
	test("%05i", (int)-2147483648);
	test("%030i", (int)-2147483648);
	test("%010i", (int)-2147483648);
	test("%011i", (int)-2147483648);
	test("%012i", (int)-2147483648);
	test("%012i, %20i, %2i, %42i", (int)-2147483648, 3, 30, -1);
	test("%012i, %i, %2i, %42i", (int)-2147483648, 3, 30, -1);
	test("%014i%020i%02i%0i", (int)-2147483648, 3, 30, -1);
	test("%014ic%020is%02ix%0iu", (int)-2147483648, 3, 30, -1);
	test("%01.i", 0);
	test("%01.0i", 0);
	test("%02.0i", 0);
	test("%03.0i", 0);
	test("%01.1i", 0);
	test("%01.2i", 0);
	test("%01.3i", 0);
	test("%01.0i", -4);
	test("%01.1i", -4);
	test("%01.2i", -4);
	test("%01.3i", -4);
	test("%01.0i", 4);
	test("%01.1i", 4);
	test("%01.2i", 4);
	test("%01.3i", 4);
	test("%010.20i", 42);
	test("%042.2i", 42000);
	test("%042.20i", 42000);
	test("%042.42i", 42000);
	test("%042.52i", 42000);
	test("%020.10i", -42000);
	test("%020.20i", -42000);
	test("%020.30i", -42000);
	test("wait for it... %050.50i", 42);
	test("%020.19i is how many tests are going to be made", 8000);
	test("%020.20i is how many tests are going to be made", 8000);
	test("%020.21i is how many tests are going to be made", 8000);
	test("%05i", 2147483647);
	test("%030i", 2147483647);
	test("%09i", 2147483647);
	test("%010i", 2147483647);
	test("%011i", 2147483647);
	test("%05i", (int)-2147483648);
	test("%030i", (int)-2147483648);
	test("%010i", (int)-2147483648);
	test("%011i", (int)-2147483648);
	test("%012i", (int)-2147483648);
	test("%012i, %20i, %2i, %000042i", (int)-2147483648, 3, 30, -1);
	test("%012i, %i, %002i, %42i", (int)-2147483648, 3, 30, -1);
	test("%0014.2i%020i%0002.i%000.5i", (int)-2147483648, 3, 30, -1);
	test("%014ic%020is%02ix%0iu", (int)-2147483648, 3, 30, -1);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_U && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%u, widths, precisions and 0");

	test("%01u", 0);
	test("%01u", -4);
	test("%010u", 42);
	test("%042u", 42000);
	test("%020u", -42000);
	test("wait for it... %050u", 42);
	test("%020u is how many tests are going to be maie", 8000);
	test("%05u", 2147483647);
	test("%030u", 2147483647);
	test("%010u", 2147483647);
	test("%05u", -1);
	test("%030u", -1);
	test("%010u", -1);
	test("%011u", -1);
	test("%012u", -1);
	test("%012u, %20u, %2u, %42u", -1, 3, 30, -1);
	test("%012u, %u, %2u, %42u", -1, 3, 30, -1);
	test("%014u%020u%02u%0u", -1, 3, 30, -1);
	test("%014uc%020us%02ux%0ui", -1, 3, 30, -1);
	test("%01.u", 0);
	test("%01.0u", 0);
	test("%02.0u", 0);
	test("%03.0u", 0);
	test("%01.1u", 0);
	test("%01.2u", 0);
	test("%01.3u", 0);
	test("%01.0u", 4);
	test("%01.1u", 4);
	test("%01.2u", 4);
	test("%01.3u", 4);
	test("%010.20u", 42);
	test("%042.2u", 42000);
	test("%042.20u", 42000);
	test("%042.42u", 42000);
	test("%042.52u", 42000);
	test("wait for it... %050.50u", 42);
	test("%020.19u is how many tests are going to be made", 8000);
	test("%020.20u is how many tests are going to be made", 8000);
	test("%020.21u is how many tests are going to be made", 8000);
	test("%05u", 2147483647);
	test("%030u", 2147483647);
	test("%09u", 2147483647);
	test("%010u", 2147483647);
	test("%011u", 2147483647);
	test("%05u",  -1);
	test("%030u", -1);
	test("%010u", -1);
	test("%011u", -1);
	test("%012u", -1);
	test("%012u, %20u, %2u, %000042u", -1, 3, 30, -1);
	test("%012u, %u, %002u, %42u", -1, 3, 30, -1);
	test("%0014.2u%020u%0002.u%000.5u", -1, 3, 30, -1);
	test("%014uc%020us%02ux%0ui", -1, 3, 30, -1);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_X && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%x, widths, precisions and 0");

	test("%01x", 0);
	test("%01x", -4);
	test("%010x", 42);
	test("%042x", 42000);
	test("%020x", -42000);
	test("wait for it... %050x", 42);
	test("%020x is how many tests are going to be made", 8000);
	test("%05x", 2147483647);
	test("%030x", 2147483647);
	test("%010x", 2147483647);
	test("%05x", -1);
	test("%030x", -1);
	test("%010x", -1);
	test("%011x", -1);
	test("%012x", -1);
	test("%012x, %20x, %2x, %42x", -1, 3, 30, -1);
	test("%012x, %x, %2x, %42x", -1, 3, 30, -1);
	test("%014x%020x%02x%0x", -1, 3, 30, -1);
	test("%014xc%020xs%02xX%0xi", -1, 3, 30, -1);
	test("%01.x", 0);
	test("%01.0x", 0);
	test("%02.0x", 0);
	test("%03.0x", 0);
	test("%01.1x", 0);
	test("%01.2x", 0);
	test("%01.3x", 0);
	test("%01.0x", 4);
	test("%01.1x", 4);
	test("%01.2x", 4);
	test("%01.3x", 4);
	test("%010.20x", 42);
	test("%042.2x", 42000);
	test("%042.20x", 42000);
	test("%042.42x", 42000);
	test("%042.52x", 42000);
	test("wait for it... %050.50x", 42);
	test("%020.19x is how many tests are going to be made", 8000);
	test("%020.20x is how many tests are going to be made", 8000);
	test("%020.21x is how many tests are going to be made", 8000);
	test("%05x", 2147483647);
	test("%030x", 2147483647);
	test("%09x", 2147483647);
	test("%010x", 2147483647);
	test("%011x", 2147483647);
	test("%05x",  -1);
	test("%030x", -1);
	test("%010x", -1);
	test("%011x", -1);
	test("%012x", -1);
	test("%012x, %20x, %2x, %000042x", -1, 3, 30, -1);
	test("%012x, %x, %002x, %42x", -1, 3, 30, -1);
	test("%0014.2x%020x%0002.x%000.5x", -1, 3, 30, -1);
	test("%014xc%020xs%02xx%0xi", -1, 3, 30, -1);

	right_cat = (g_all_bonus & CAT_BONUS_1) ? 1
			: test_cat ? (test_cat & CAT_BIG_X && test_cat & CAT_BONUS_1)
			: 1;
	describe("\n%X, widths, precisions and 0");

	test("%01X", 0);
	test("%01X", -4);
	test("%010X", 42);
	test("%042X", 42000);
	test("%020X", -42000);
	test("wait for it... %050X", 42);
	test("%020X is how many tests are going to be made", 8000);
	test("%05X", 2147483647);
	test("%030X", 2147483647);
	test("%010X", 2147483647);
	test("%05X", -1);
	test("%030X", -1);
	test("%010X", -1);
	test("%011X", -1);
	test("%012X", -1);
	test("%012X, %20X, %2X, %42X", -1, 3, 30, -1);
	test("%012X, %X, %2X, %42X", -1, 3, 30, -1);
	test("%014X%020X%02X%0X", -1, 3, 30, -1);
	test("%014Xc%020Xs%02XX%0Xi", -1, 3, 30, -1);
	test("%01.X", 0);
	test("%01.0X", 0);
	test("%02.0X", 0);
	test("%03.0X", 0);
	test("%01.1X", 0);
	test("%01.2X", 0);
	test("%01.3X", 0);
	test("%01.0X", 4);
	test("%01.1X", 4);
	test("%01.3X", 4);
	test("%010.20X", 42);
	test("%042.2X", 42000);
	test("%042.20X", 42000);
	test("%042.42X", 42000);
	test("%042.52X", 42000);
	test("wait for it... %050.50X", 42);
	test("%020.19X is how many tests are going to be made", 8000);
	test("%020.20X is how many tests are going to be made", 8000);
	test("%020.21X is how many tests are going to be made", 8000);
	test("%05X", 2147483647);
	test("%030X", 2147483647);
	test("%09X", 2147483647);
	test("%010X", 2147483647);
	test("%011X", 2147483647);
	test("%05X",  -1);
	test("%030.20X", -1);
	test("%010.11X", -1);
	test("%011.11X", -1);
	test("%012.11X", -1);
	test("%012X, %20X, %2X, %000042.20X", -1, 3, 30, -1);
	test("%012X, %X, %002X, %42.5X", -1, 3, 30, -1);
	test("%0014.2X%020X%0002.X%000.5X", -1, 3, 30, -1);
	test("%014Xc%020Xs%02.5XX%0.Xi", -1, 3, 30, -1);

	right_cat = (g_all_bonus & CAT_BONUS_2) ? 1
			: test_cat ? (test_cat & CAT_X && test_cat & CAT_BONUS_2)
			: 1;
	describe("\n%x and #");

	test("%#x", 0);
	test("%#x", -4);
	test("%#x", 42);
	test("%#x", 42000);
	test("%#x", -42000);
	test("wait for it... %#x", 42);
	test("%#x is how many tests are going to be made", 8000);
	test("%#xd", 2147483647);
	test("%#xp", 2147483647);
	test("%#xX", 2147483647);
	test("%#xp", -1);
	test("%#xd", -1);
	test("%#xX", -1);
	test("%#x", -1);
	test("%#x, %x, %x, %x", -1, 3, 30, -1);
	test("%#x%#x%#x%#x", -1, 3, 30, -1);
	test("%#xc%#xs%#xX%#xi", -1, 3, 30, -1);
	test("--.%#xp", 0);
	test("--.%#xs", 0);
	test("%#xc", 4);
	test("c%#x-i", 42000);
	test("wait for it... %#xp", 42);

	right_cat = (g_all_bonus & CAT_BONUS_2) ? 1
			: test_cat ? (test_cat & CAT_BIG_X && test_cat & CAT_BONUS_2)
			: 1;
	describe("\n%X and #");

	test("%#X", 0);
	test("%#X", -4);
	test("%#X", 42);
	test("%#X", 42000);
	test("%#X", -42000);
	test("wait for it... %#X", 42);
	test("%#X is how many tests are going to be made", 8000);
	test("%#Xd", 2147483647);
	test("%#Xp", 2147483647);
	test("%#XX", 2147483647);
	test("%#Xp", -1);
	test("%#Xd", -1);
	test("%#XX", -1);
	test("%#X", -1);
	test("%#X, %X, %X, %X", -1, 3, 30, -1);
	test("%#X%#X%#X%#X", -1, 3, 30, -1);
	test("%#Xc%#Xs%#Xx%#Xi", -1, 3, 30, -1);
	test("--.%#Xp", 0);
	test("--.%#Xs", 0);
	test("%#Xc", 4);
	test("c%#X-i", 42000);
	test("wait for it... %#Xp", 42);

	right_cat = (g_all_bonus & CAT_BONUS_2) ? 1
			: test_cat ? (test_cat & CAT_D && test_cat & CAT_BONUS_2)
			: 1;
	describe("\n%d and ' '");

	test("% d", 0);
	test("% d", 1);
	test("% d", -1);
	test("%    d", 0);
	test("%   d", 1);
	test("%  d", -1);
	test("% d", 2147483647);
	test("% d", (int)-2147483648);
	test("%   d", 2147483647);
	test("%  d", (int)-2147483648);
	test("% d", 2178647);
	test("% d", (int)-2144348);
	test("%   d", 2147837);
	test("%  d", (int)-2147486);
	test("%  d this is %d getting% di hard :/", (int)-2147486, -2, 42);

	right_cat = (g_all_bonus & CAT_BONUS_2) ? 1
			: test_cat ? (test_cat & CAT_I && test_cat & CAT_BONUS_2)
			: 1;
	describe("\n%i and ' '");

	test("% i", 0);
	test("% i", 2);
	test("% i", -2);
	test("%    i", 0);
	test("%   i", 1);
	test("%  i", -1);
	test("% i", 2147483647);
	test("% i", (int)-2147483648);
	test("%   i", 2147483647);
	test("%  i", (int)-2147483648);
	test("% i", 2178647);
	test("% i", (int)-2144348);
	test("%   i", 2147837);
	test("%  i", (int)-2147486);
	test("%  i this is %i getting% is hari :/", (int)-2147486, -2, 42);

	right_cat = (g_all_bonus & CAT_BONUS_2) ? 1
			: test_cat ? (test_cat & CAT_D && test_cat & CAT_BONUS_2)
			: 1;
	describe("\n%d and +");

	test("%+d", 0);
	test("%+d", 1);
	test("%+d", -1);
	test("%+d", 24);
	test("%+d", 42);
	test("%+d", -42);
	test("%+d", 2147483647);
	test("%+d", (int)-2147483648);
	test("%+++d", 2147483647);
	test("%++d", (int)-2147483648);
	test("%+d", 2178647);
	test("%+d", (int)-2144348);
	test("%+++d", 2147837);
	test("%++d", (int)-2147486);
	test("%++d this is %d getting%+di hard :/", (int)-2147486, -2, 42);

	right_cat = (g_all_bonus & CAT_BONUS_2) ? 1
			: test_cat ? (test_cat & CAT_I && test_cat & CAT_BONUS_2)
			: 1;
	describe("\n%d and +");

	test("%+i", 0);
	test("%+i", 1);
	test("%+i", -1);
	test("%+i", 24);
	test("%+i", 42);
	test("%+i", -42);
	test("%+i", 2147483647);
	test("%+i", (int)-2147483648);
	test("%+++i", 2147483647);
	test("%++i", (int)-2147483648);
	test("%+i", 2178647);
	test("%+i", (int)-2144348);
	test("%+++i", 2147837);
	test("%++i", (int)-2147486);
	test("%++i this is %i getting%+ix hard :/", (int)-2147486, -2, 42);
}
