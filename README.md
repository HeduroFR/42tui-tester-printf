The SupraTester for the 42 school ft_printf (Linux ~~Mac Os~~)

# INSTALLATION

	clone the repo inside your ft_printf or next to it.
	run './install.sh' to compile and install the printf_tester
	the `printf_tester` file has been created
	run it with `./printf_tester` (mandatory part)
	or with `./printf_tester --bonus` (mandatory + bonus part)

# REQUIREMENTS
	``vala``
	``a C compiler (clang or gcc)``
	``nasm``
	``meson and ninja``

# NOTES

The tester looks for your Makefile in the current folder, then in `../ft_printf/`, `../printf/`, `../`
and finally in every folder of the current one. It runs `make` (and `make bonus` with `--bonus`)
and builds a `libftprintf.so` from your `libftprintf.a`.

Each test calls your `ft_printf` and the real `printf` with the same arguments
and compares the output (even after a `'\0'`) and the return value.
The reference is the glibc of your computer, so `NULL` gives `(null)` for `%s` and `(nil)` for `%p`.

The bonus tests only use the flags of the subject (`-0.# +` and the width)
and skip every combination that is undefined behaviour (`%#d`, `%05s`, `%.3p`, `% u`...).

At the end, the tester lists the forbidden functions used by your `libftprintf.a`.

The tester updates itself with `git pull` in the background when it's a git clone.

# SupraTester

It loads your ft_printf and tests it
asynchronously and fast on several processors.

Every test runs in its own process, so a crash or an infinite loop is reported without stopping the others.

An idea? Something else? Open an issue!
