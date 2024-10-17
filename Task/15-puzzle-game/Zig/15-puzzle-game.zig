const std = @import("std");
const stdout = std.io.getStdOut().writer();

const tokens = [16][]const u8{ " 1", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", "10", "11", "12", "13", "14", "15", "  " };

const empty_token = 15;
var empty: u8 = empty_token;
var cells: [16]u8 = undefined;
var invalid: bool = false;

const Move = enum { no, up, down, left, right };

fn showBoard() !void {
    try stdout.writeAll("\n");

    var solved = true;
    var i: u8 = 0;
    while (i < 16) : (i += 1) {
        try stdout.print(" {s} ", .{tokens[cells[i]]});
        if ((i + 1) % 4 == 0) try stdout.writeAll("\n");
        if (i != cells[i]) solved = false;
    }

    try stdout.writeAll("\n");

    if (solved) {
        try stdout.writeAll("\n\n** You did it! **\n\n");
        std.posix.exit(0);
    }
}

fn updateToken(move: Move) !void {
    const newEmpty = switch (move) {
        Move.up => if (empty / 4 < 3) empty + 4 else empty,
        Move.down => if (empty / 4 > 0) empty - 4 else empty,
        Move.left => if (empty % 4 < 3) empty + 1 else empty,
        Move.right => if (empty % 4 > 0) empty - 1 else empty,
        else => empty,
    };

    if (empty == newEmpty) {
        invalid = true;
    } else {
        invalid = false;
        cells[empty] = cells[newEmpty];
        cells[newEmpty] = empty_token;
        empty = newEmpty;
    }
}

fn waitForMove() !Move {
    const reader = std.io.getStdIn().reader();
    if (invalid) try stdout.writeAll("(invalid) ");
    try stdout.writeAll("enter u/d/l/r or q: ");
    const input = try reader.readBytesNoEof(2);
    switch (std.ascii.toLower(input[0])) {
        'q' => std.posix.exit(0),
        'u' => return Move.up,
        'd' => return Move.down,
        'l' => return Move.left,
        'r' => return Move.right,
        else => return Move.no,
    }
}

fn shuffle(moves: u8) !void {
    var random = std.Random.DefaultPrng.init(@intCast(std.time.microTimestamp()));
    const rand = random.random();
    var n: u8 = 0;
    while (n < moves) {
        const move: Move = rand.enumValue(Move);
        try updateToken(move);
        if (!invalid) n += 1;
    }
    invalid = false;
}

pub fn main() !void {
    var n: u8 = 0;
    while (n < 16) : (n += 1) {
        cells[n] = n;
    }

    try shuffle(50);
    try showBoard();

    while (true) {
        try updateToken(try waitForMove());
        try showBoard();
    }
}
