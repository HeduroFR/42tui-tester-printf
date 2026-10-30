# 42TUI portability fork

The upstream test cases and attribution are retained. This branch replaces the x86 assembly argument forwarding and asynchronous capture path with direct variadic C calls. Linux arm64 containers can run natively on Apple Silicon; Linux amd64 remains supported. This is not a native macOS runner.

## Run in Docker

Build on the target architecture (Docker selects it by default):

```sh
docker build -t supra-portable .
```

Run against a **disposable copy** of your project. The tester runs its Makefile and writes build artifacts. Remove host-built objects first, or run `make fclean` in the copy before testing. The 42TUI adapter already rebuilds its disposable copy for Linux.

```sh
docker run --rm --network none --read-only --cap-drop ALL \
  --security-opt no-new-privileges --pids-limit 512 \
  --tmpfs /tmp:rw,exec,nosuid,nodev,size=256m \
  --mount "type=bind,source=/absolute/path/to/disposable-copy,target=/project" \
  supra-portable --report /project/result.json
```

Add `--bonus` to include bonus tests. Report destinations must not already exist. A failed build does not publish a report. Exit codes: 0 for all checks passed, 1 for test/forbidden-function failures or capture errors, 2 for setup/build/report failures. Docker's watchdog returns 124 on its ten-minute deadline.

## Runner behavior

Each existing `TEST` invocation forks a student child and a reference child sequentially, while argument expressions remain in scope. The C compiler handles the native calling convention. No saved `va_list` or assembly bridge crosses asynchronous frames.

Binary stdout, including embedded NUL bytes, and return values are compared. A private file descriptor carries the return value and existing allocator counters; stderr cannot forge those records. The original malloc/free interposition remains; allocation balance is not a full memory safety check. Forbidden symbols are counted as additional failed checks.

Each child has a two-second deadline and a one-MiB file limit. Process groups are cleaned before the leader is reaped. Linux kills the direct child if the runner dies. Docker provides the outer process boundary; these controls are not a sandbox for hostile code.

Reference output comes from Debian glibc. Results for undefined C inputs are platform-dependent; retaining upstream cases does not make those inputs portable language guarantees. Tests run sequentially, trading parallel throughput for a simpler lifecycle.

The optional version-1 JSON report contains `version`, `total`, `passed`, `failed`, `errors`, and `skipped`. It is written after checks complete. Client integration must use a pinned fork commit and consume the report before treating a zero exit as verified test success.

## Validation

```sh
python3 tests/check_capture.py
docker build -f tests/docker/capture.Dockerfile .
python3 tests/check_container.py supra-portable
```

The first command needs a C compiler. The container checks build a synthetic printf wrapper: 503 mandatory comparisons and 1,629 mandatory-plus-bonus comparisons must pass. Its deliberate use of forbidden `vprintf` adds one expected failure. Checks also reject stale reports and failed builds. Capture regressions cover argument forwarding beyond registers, embedded NUL differences, return mismatches, allocator imbalance, crashes, and timeouts.

Local validation runs Linux arm64 natively and Linux amd64 under Docker Desktop emulation on Apple Silicon. The proposed workflow in `ci/portable.yml` adds native amd64 and arm64 runners. It is not enabled: the current GitHub OAuth token lacks workflow scope. Move it to `.github/workflows/portable.yml` with authorized workflow credentials, then check the remote runs.

## Upstream coordination

No upstream pull request has been opened. The checkout has no declared license; clarify redistribution terms with the author before publishing modified binaries or container images. No license is assumed or added by this fork.
