const std = @import("std");

fn Run(comptime T: type) type {
    return struct {
        value: T,
        length: usize,
    };
}

fn encode(
    comptime T: type,
    input: []const T,
    allocator: std.mem.Allocator,
) ![]Run(T) {
    var runs = std.ArrayList(Run(T)).init(allocator);
    defer runs.deinit();

    var previous: ?T = null;
    var length: usize = 0;

    for (input) |current| {
        if (previous == current) {
            length += 1;
        } else if (previous) |value| {
            try runs.append(.{
                .value = value,
                .length = length,
            });
            previous = current;
            length = 1;
        } else {
            previous = current;
            length += 1;
        }
    }

    if (previous) |value| {
        try runs.append(.{
            .value = value,
            .length = length,
        });
    }

    return runs.toOwnedSlice();
}

test encode {
    const input =
        "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW";

    const expected = [_]Run(u8){
        .{ .length = 12, .value = 'W' },
        .{ .length = 1, .value = 'B' },
        .{ .length = 12, .value = 'W' },
        .{ .length = 3, .value = 'B' },
        .{ .length = 24, .value = 'W' },
        .{ .length = 1, .value = 'B' },
        .{ .length = 14, .value = 'W' },
    };

    const allocator = std.testing.allocator;
    const actual = try encode(u8, input, allocator);
    defer allocator.free(actual);

    try std.testing.expectEqual(expected.len, actual.len);
    for (expected, actual) |e, a| {
        try std.testing.expectEqual(e.length, a.length);
        try std.testing.expectEqual(e.value, a.value);
    }
}

fn decode(
    comptime T: type,
    runs: []const Run(T),
    allocator: std.mem.Allocator,
) ![]T {
    var values = std.ArrayList(T).init(allocator);
    defer values.deinit();
    for (runs) |r|
        try values.appendNTimes(r.value, r.length);
    return values.toOwnedSlice();
}

test decode {
    const runs = [_]Run(u8){
        .{ .length = 12, .value = 'W' },
        .{ .length = 1, .value = 'B' },
        .{ .length = 12, .value = 'W' },
        .{ .length = 3, .value = 'B' },
        .{ .length = 24, .value = 'W' },
        .{ .length = 1, .value = 'B' },
        .{ .length = 14, .value = 'W' },
    };

    const allocator = std.testing.allocator;
    const decoded = try decode(u8, &runs, allocator);
    defer allocator.free(decoded);

    try std.testing.expectEqualStrings(
        "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW",
        decoded,
    );
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);

    const allocator = gpa.allocator();
    var input = std.ArrayList(u8).init(allocator);
    defer input.deinit();

    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    try stdout.print("Input: ", .{});
    try stdin.streamUntilDelimiter(input.writer(), '\n', null);

    const runs = try encode(u8, input.items, allocator);
    defer allocator.free(runs);

    try stdout.print("Encoded:\n", .{});
    for (runs) |r|
        try stdout.print("  {}\n", .{r});

    const decoded = try decode(u8, runs, allocator);
    defer allocator.free(decoded);

    try stdout.print("Decoded: {s}\n", .{decoded});
}
