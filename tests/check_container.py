"""Run actual Vala suites in Docker using only disposable synthetic projects."""
import json
import pathlib
import subprocess
import sys
import tempfile

image = sys.argv[1]
with tempfile.TemporaryDirectory(prefix="supra fixture '") as directory:
    project = pathlib.Path(directory)
    (project / "ft_printf.c").write_text('''#include <stdio.h>
#include <stdarg.h>
int ft_printf(const char *format, ...) {
    va_list arguments;
    va_start(arguments, format);
    int result = vprintf(format, arguments);
    va_end(arguments);
    return result;
}
''')
    (project / "Makefile").write_text('''all: libftprintf.a
libftprintf.a: ft_printf.o
	ar rcs $@ $<
ft_printf.o: ft_printf.c
	cc -Wall -Wextra -Werror -fPIC -c $< -o $@
bonus: all
''')
    base = ["docker", "run", "--rm", "--network", "none", "--read-only", "--cap-drop", "ALL", "--pids-limit", "512",
            "--tmpfs", "/tmp:rw,exec,nosuid,nodev,size=256m",
            "--security-opt", "no-new-privileges=true", "--mount", f'type=bind,"source={directory}",target=/project', image]
    reports = []
    for bonus in (False, True):
        name = "bonus.json" if bonus else "mandatory.json"
        run = subprocess.run(base + (["--bonus"] if bonus else []) + ["--report", "/project/" + name],
                             capture_output=True, timeout=120)
        report = json.loads((project / name).read_text())
        output = run.stdout.decode(errors="replace")
        # Every comparison passes; the synthetic libc shortcut is explicitly forbidden.
        assert run.returncode == 1, (run.returncode, output[-2000:], run.stderr)
        assert report["failed"] == 1 and report["errors"] == 0, (report, output[-2000:])
        assert report["total"] == sum(report[k] for k in ("passed", "failed", "errors", "skipped"))
        assert "Forbidden Function" in output and "vprintf" in output, output[-2000:]
        reports.append(report)
        print(name, json.dumps(report))
    assert reports[0]["passed"] == 503, reports
    assert reports[1]["passed"] == 1629, reports
    # Reusing a report must never present stale success after a failed run.
    duplicate = subprocess.run(base + ["--report", "/project/mandatory.json"], capture_output=True, timeout=10)
    assert duplicate.returncode == 2
    assert json.loads((project / "mandatory.json").read_text()) == reports[0]
    # Build failure cannot fall back to a stale archive or wait for terminal input.
    (project / "Makefile").write_text("all:\n\tfalse\n")
    failed = subprocess.run(base + ["--report", "/project/failed.json"], capture_output=True, timeout=10)
    assert failed.returncode == 2 and not (project / "failed.json").exists()
    print("stale report and failed build rejected")
