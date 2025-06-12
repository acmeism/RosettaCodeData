const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const examples = [_][]const u8{ "broood", "bananaaa", "hiphophiphop" };

    for (examples) |example| {
        const encoded = try encode(allocator, example);
        defer allocator.free(encoded);

        const decoded = try decode(allocator, encoded);
        defer allocator.free(decoded);

        std.debug.print("{s} encodes to {any} decodes to {s}\n", .{ example, encoded, decoded });
    }
}

fn getSymbols(allocator: std.mem.Allocator) ![]u8 {
    var symbols = std.ArrayList(u8).init(allocator);
    errdefer symbols.deinit();

    var c: u8 = 'a';
    while (c <= 'z') : (c += 1) {
        try symbols.append(c);
    }

    return symbols.toOwnedSlice();
}

fn encode(allocator: std.mem.Allocator, input: []const u8) ![]usize {
    var output = std.ArrayList(usize).init(allocator);
    errdefer output.deinit();

    var symbols = try getSymbols(allocator);
    defer allocator.free(symbols);

    for (input) |byte| {
        // Find position of the byte in symbols
        var position: usize = 0;
        for (symbols, 0..) |symbol, i| {
            if (symbol == byte) {
                position = i;
                break;
            }
        }

        // Remove the byte at the position
        const char = symbols[position];
        std.mem.copyForwards(u8, symbols[1..position + 1], symbols[0..position]);
        symbols[0] = char;

        try output.append(position);
    }

    return output.toOwnedSlice();
}

fn decode(allocator: std.mem.Allocator, input: []const usize) ![]u8 {
    var output = std.ArrayList(u8).init(allocator);
    errdefer output.deinit();

    var symbols = try getSymbols(allocator);
    defer allocator.free(symbols);

    for (input) |position| {
        try output.append(symbols[position]);

        // Remove the byte at the position
        const char = symbols[position];
        std.mem.copyForwards(u8, symbols[1..position + 1], symbols[0..position]);
        symbols[0] = char;
    }

    return output.toOwnedSlice();
}
