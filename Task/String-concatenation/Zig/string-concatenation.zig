const std = @import("std");

const debug = std.debug;
const heap = std.heap;
const mem = std.mem;

test "string concatenation" {
    const hello = "Hello,";

    debug.warn("\n{}{}\n", .{ hello, " world!" });

    // Method 1: Array concatenation
    //
    // This only works if the values are known at compile-time.
    const hello_world_at_comptime = hello ++ " world!";

    debug.warn("{}\n", .{hello_world_at_comptime});

    // Method 2: std.mem.concat
    var buf: [128]u8 = undefined;
    const allocator = &heap.FixedBufferAllocator.init(&buf).allocator;

    const hello_world_concatenated = try mem.concat(allocator, u8, &[_][]const u8{ hello, " world!" });

    debug.warn("{}\n", .{hello_world_concatenated});

    // Method 3: std.mem.join
    const hello_world_joined = try mem.join(allocator, " ", &[_][]const u8{ hello, "world!" });

    debug.warn("{}\n", .{hello_world_joined});
}
