const std = @import("std");

const Block: type = struct { Char1: u8, Char2: u8 };
const BLOCK_SIZE: comptime_int = 20;
const blocks: [BLOCK_SIZE]Block = .{
    .{ .Char1 = 'B', .Char2 = 'O' }, .{ .Char1 = 'X', .Char2 = 'K' },
    .{ .Char1 = 'D', .Char2 = 'Q' }, .{ .Char1 = 'C', .Char2 = 'P' },
    .{ .Char1 = 'N', .Char2 = 'A' }, .{ .Char1 = 'G', .Char2 = 'T' },
    .{ .Char1 = 'R', .Char2 = 'E' }, .{ .Char1 = 'T', .Char2 = 'G' },
    .{ .Char1 = 'Q', .Char2 = 'D' }, .{ .Char1 = 'F', .Char2 = 'S' },
    .{ .Char1 = 'J', .Char2 = 'W' }, .{ .Char1 = 'H', .Char2 = 'U' },
    .{ .Char1 = 'V', .Char2 = 'I' }, .{ .Char1 = 'A', .Char2 = 'N' },
    .{ .Char1 = 'O', .Char2 = 'B' }, .{ .Char1 = 'E', .Char2 = 'R' },
    .{ .Char1 = 'F', .Char2 = 'S' }, .{ .Char1 = 'L', .Char2 = 'Y' },
    .{ .Char1 = 'P', .Char2 = 'C' }, .{ .Char1 = 'Z', .Char2 = 'M' },
};

fn can_make_word(word: []const u8) bool {
    var marked: [BLOCK_SIZE]bool = [_]bool{false} ** BLOCK_SIZE;

    for (word) |char| {
        var hasBlock: bool = false;

        for (blocks, 0..) |block, index| {
            if ((block.Char1 == char or block.Char2 == char) and !marked[index]) {
                hasBlock = true;
                marked[index] = true;
                break;
            }
        }

        if (!hasBlock) {
            return false;
        }
    }

    return true;
}

pub fn main() !void {
    const words: []const []const u8 = &.{
        "A",
        "BARK",
        "BOOK",
        "TREAT",
        "COMMON",
        "SQUAD",
        "CONFUSE",
    };

    for (words) |word| {
        std.debug.print("{s}\t{any}\n", .{ word, can_make_word(word) });
    }
}
