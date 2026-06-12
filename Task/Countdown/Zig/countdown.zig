const std = @import("std");
const Writer = std.Io.Writer;

const Op = enum { add, mul, sub, div };

fn printSlice(stdout: *Writer, slice: []const u32) !void {
    try stdout.writeAll("Using : [");
    for (slice, 0..) |item, i| {
        if (i > 0) try stdout.writeAll(", ");
        try stdout.print("{d}", .{item});
    }
    try stdout.writeAll("]\n");
}

fn apply(op: Op, a: u32, b: u32) ?u32 {
    return switch (op) {
        .add => a + b,
        .mul => if (b != 1) a * b else null,
        .sub => if (a != b) a - b else null,
        .div => if (b != 1 and a % b == 0) @divExact(a, b) else null,
    };
}

fn opChar(op: Op) u8 {
    return switch (op) {
        .add => '+',
        .mul => '*',
        .sub => '-',
        .div => '/',
    };
}

fn countdown(stdout: *Writer, numbers: []u32, target: u32) !?void {
    if (numbers.len <= 1) return null;

    const ops = [_]Op{ .add, .mul, .sub, .div };

    for (0..numbers.len) |i| {
        for (i + 1..numbers.len) |j| {
            const hi = @max(numbers[i], numbers[j]);
            const lo = @min(numbers[i], numbers[j]);

            // Build reduced list: remove i and j, compact the rest
            var buf: [24]u32 = undefined;
            var len: usize = 0;
            for (0..numbers.len) |k| {
                if (k != i and k != j) {
                    buf[len] = numbers[k];
                    len += 1;
                }
            }

            for (ops) |op| {
                if (apply(op, hi, lo)) |result| {
                    buf[len] = result;

                    if (result == target or try countdown(stdout, buf[0 .. len + 1], target) != null) {
                        try stdout.print("{d} = {d} {c} {d}\n", .{ result, hi, opChar(op), lo });
                        return {};
                    }
                }
            }
        }
    }

    return null;
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var all_numbers = [_]u32{ 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100 };

    var random_source = std.Random.IoSource{ .io = io };
    const random = random_source.interface();
    random.shuffle(u32, &all_numbers);

    const number_lists = [_][]const u32{
        &[_]u32{ 3, 6, 25, 50, 75, 100 },
        &[_]u32{ 100, 75, 50, 25, 6, 3 },
        &[_]u32{ 8, 4, 4, 6, 8, 9 },
        all_numbers[0..6],
    };

    const target_list = [_]u32{ 952, 952, 594, random.intRangeAtMost(u32, 101, 999) };

    var stdout_writer = std.Io.File.stdout().writer(io, &.{});
    const stdout = &stdout_writer.interface;

    const start = std.Io.Clock.awake.now(io);

    for (number_lists, target_list) |numbers, target| {
        try printSlice(stdout, numbers);
        try stdout.print("Target: {d}\n", .{target});

        var buf: [24]u32 = undefined;
        @memcpy(buf[0..numbers.len], numbers);

        if (try countdown(stdout, buf[0..numbers.len], target) == null) {
            try stdout.writeAll("No solution found\n");
        }
        try stdout.writeAll("\n");
    }

    const elapsed = start.untilNow(io, .awake);
    std.debug.print("Took {} ms\n", .{elapsed.toMilliseconds()});
}
