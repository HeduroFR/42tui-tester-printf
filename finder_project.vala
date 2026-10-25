public const string p_supra= "\033[33;1m[SupraTester]\033[0m\033[37m ";
public const string p_none = "\033[0m";

/**
 * Search for Makefile in common ft_printf locations and generate libftprintf.so
 * @return Path to generated libftprintf.so
 * @throws Error if no Makefile is found or generation fails
 */
string? find_libftprintf() throws Error {
	var pwd = Environment.get_current_dir();

	// search in folder pwd/Makefile
	if (FileUtils.test(@"$pwd/Makefile", FileTest.EXISTS))
		return generate_libftprintf_so (@"$pwd/");

	// search in folder pwd/../ft_printf/Makefile and pwd/../printf/Makefile
	foreach (unowned var sibling in new string[]{"ft_printf", "printf"}) {
		var folder = @"$pwd/../$sibling/";
		if (FileUtils.test(@"$folder/Makefile", FileTest.EXISTS))
			return generate_libftprintf_so (folder);
	}

	// search in folder pwd/../Makefile
	if (FileUtils.test(@"$pwd/../Makefile", FileTest.EXISTS))
		return generate_libftprintf_so (@"$pwd/../");

	// search in folder pwd/**/Makefile
	var dir = Dir.open(pwd);
	unowned string? name;

	while ((name = dir.read_name ()) != null) {
		var folder = Path.build_filename (pwd, name);
		if (FileUtils.test(folder, FileTest.IS_DIR)) {
			if (FileUtils.test(@"$folder/Makefile", FileTest.EXISTS)) {
				return generate_libftprintf_so (folder);
			}
		}
	}
	throw new FileError.ACCES ("No Makefile found\n");
}

/**
 * Remove the temporary folder created by extract_libftprintf_so
 * @param tmp_dir Path to the vala_libsoXXXXXX folder
 */
void remove_tmp_dir (string tmp_dir) {
	if (!Path.get_basename (tmp_dir).has_prefix ("vala_libso"))
		return;
	try {
		var dir = Dir.open (tmp_dir);
		unowned string? name;
		while ((name = dir.read_name ()) != null)
			FileUtils.unlink (Path.build_filename (tmp_dir, name));
	}
	catch (Error e) {
		return;
	}
	DirUtils.remove (tmp_dir);
}

/**
 * Extract libftprintf.a into a temporary folder and generate libftprintf.so from object files
 * @param libftprintf_a Path to libftprintf.a
 * @return Path to generated libftprintf.so
 * @throws Error if extraction or generation fails
 */
string extract_libftprintf_so (string libftprintf_a) throws Error {
	string tmp_dir = DirUtils.make_tmp("vala_libsoXXXXXX");
	string error_str;
	int wait_status;

	Process.spawn_sync(tmp_dir,
		{"ar", "-xv", libftprintf_a},
		null,
		SpawnFlags.SEARCH_PATH + SpawnFlags.STDOUT_TO_DEV_NULL,
		null,
		null,
		out error_str,
		out wait_status);

	if (wait_status != 0) {
		remove_tmp_dir (tmp_dir);
		throw new FileError.ACCES ("Can't extract object file from libftprintf.a %s\n", error_str);
	}

	Dir dir = Dir.open (tmp_dir);
	string result_so = Path.build_filename (tmp_dir, "libftprintf.so");
	string []command = {"cc", "--shared", "-o", result_so};
	unowned string name;
	while ((name = dir.read_name ()) != null) {
		if (name.has_suffix(".o"))
			command += Path.build_filename (tmp_dir, name);
	}

	Process.spawn_sync(null,
		command,
		null,
		SpawnFlags.SEARCH_PATH + SpawnFlags.STDOUT_TO_DEV_NULL,
		null,
		null,
		out error_str,
		out wait_status);

	if (wait_status != 0) {
		remove_tmp_dir (tmp_dir);
		throw new FileError.ACCES ("Can't generate libftprintf.so from object files %s\n", error_str);
	}

	return result_so;
}

/**
  * Run make in the given directory to generate libftprintf.a and libftprintf.so
  * @param dir_makefile Directory containing the Makefile
  * @return Path to generated libftprintf.so
  * @throws Error if make fails or libftprintf.so cannot be generated
  */
public string? generate_libftprintf_so (string dir_makefile) throws Error {
	stdout.printf(p_supra + "Makefile found here: %s" + p_none + "\n", Path.build_filename (dir_makefile, "Makefile"));

	string errput;
	int wait_status;
	SpawnFlags flags = SpawnFlags.SEARCH_PATH + SpawnFlags.STDOUT_TO_DEV_NULL;
	Process.spawn_sync(null, {"make", "all", "-C", dir_makefile}, null, flags, null, null, out errput, out wait_status);
	Process.spawn_sync(null, {"make", "bonus", "-C", dir_makefile}, null, flags + SpawnFlags.STDERR_TO_DEV_NULL, null, null);


	if (wait_status != 0) {
		stderr.printf(p_supra + "Error while running make in %s\n" + p_none, dir_makefile);
		stderr.printf(p_supra + "\033[0m%s%s\n", errput, p_none);
		if (!FileUtils.test(@"$dir_makefile/libftprintf.a", FileTest.EXISTS))
			throw new FileError.ACCES ("Error while running make (no libftprintf.a)\n");

		stderr.printf(p_supra + "Do you want running your last libftprintf.a ? [y/N]");
		string? answer = stdin.read_line();
		if (answer == null || answer.strip().ascii_down() != "y")
			throw new FileError.ACCES ("Error while running make\n");
	}

	stderr.printf(p_supra + "[Generate] libftprintf.so from libftprintf.a\n" + p_none);
	string libftprintf_so = extract_libftprintf_so(@"$dir_makefile/libftprintf.a");
	if (FileUtils.test(libftprintf_so, FileTest.EXISTS))
		return libftprintf_so;
	throw new FileError.ACCES ("Can't generate libftprintf.so from libftprintf.a ???\n");
}
