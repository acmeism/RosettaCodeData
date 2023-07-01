const std = @import("std");

const debug = std.debug;
const heap = std.heap;
const process = std.process;

pub fn main() !void {
    var args = process.args();

    const program_name = try args.next(heap.page_allocator) orelse unreachable;
    defer heap.page_allocator.free(program_name);

    debug.warn("{}\n", .{program_name});
}
