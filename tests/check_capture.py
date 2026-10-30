"""Real subprocess regressions for ABI forwarding and capture failures; no student data."""
import pathlib
import subprocess
import tempfile
import time

root = pathlib.Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix="supra-capture-") as directory:
    binary = pathlib.Path(directory) / "capture-test"
    subprocess.run(["cc", "-std=c11", "-Wall", "-Wextra", "-Werror", "-I", str(root),
                    str(root / "capture.c"), str(root / "tests/capture_harness.c"), "-o", str(binary)], check=True)
    for mode in ("good", "return", "binary", "leak", "crash", "timeout"):
        started = time.monotonic()
        process = subprocess.run([str(binary), mode], capture_output=True, timeout=8)
        output = process.stdout.decode(errors="replace")
        assert process.returncode == (0 if mode == "good" else 1), (mode, output, process.stderr)
        assert ("counts 4 0 0" if mode == "good" else "counts 1 1 0") in output, (mode, output)
        if mode == "binary": assert "\\0wrong" in output and "\\0right" in output, output
        if mode == "timeout":
            assert "TIMEOUT" in output, output
            assert 1.8 <= time.monotonic() - started < 6
        print(mode, "passed")
