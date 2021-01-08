event-processor: zig-cache/bin/event-processor
	@cp zig-cache/bin/event-processor event-processor
	@strip event-processor

zig-cache/bin/event-processor: src/main.zig
	@zig build -Drelease-safe=true

clean:
	@rm -r zig-cache
	@rm event-processor
