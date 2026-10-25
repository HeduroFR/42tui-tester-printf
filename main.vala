

async void main()
{
	Intl.setlocale();
	string libftprintf_so;
	try {
		libftprintf_so = find_libftprintf ();
	}
	catch (Error e) {
		stderr.printf ("\033[31m[SupraTest]\033[0m %s", e.message);
		return;
	}
	load_ft_printf (libftprintf_so);

	yield describe("%c Test");
	test_char();
	yield describe("%s Test");
	test("%s", "Hello");
	test("%s", "World");
	yield describe(null);
	remove_tmp_dir (Path.get_dirname (libftprintf_so));
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
