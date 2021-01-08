# Event processor

This project creates a web server, listening on port 9090, that will capture
all requests and send the path, method, headers and body in JSON format
asynchronously to a program called "event-processor", which can then do
whatever it wants with it.

# Building

Install zig 0.7.1 from https://ziglang.org/download/. Once downloaded, you
can unpackage the download and get the main executable in your path (zig
figures out the other files it needs based on where the main executable lies).

You can either run "make" using the Makefile provided, or run `zig build`.
Doing the latter will land the binary in ./zig-cache/bin. The makefile uses
-Drelease-safe=true to provide a small, statically-linked reproducible binary,
which is then stripped and copied to "event-processor-backend" in the
current directory.
