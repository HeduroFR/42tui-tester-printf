FROM debian:bookworm-slim@sha256:99c0b25c46d0214d5a2091092e7908907dcaecd6a962cde0ac700acee222b6f3
RUN apt-get update && apt-get install -y --no-install-recommends gcc libc6-dev python3 && rm -rf /var/lib/apt/lists/*
WORKDIR /source
COPY . .
RUN python3 tests/check_capture.py
