const std = @import("std");

const Box = struct {
    piles: [3][3]u8,

    fn init(piles: [3][3]u8) Box {
        var a = Box{ .piles = piles };

        for (a.piles) |row| {
            for (row) |pile| {
                if (pile >= 4) {
                    return a.avalanche();
                }
            }
        }
        return a;
    }

    fn avalanche(self: *const Box) Box {
        var a = self.*;
        for (self.piles, 0..) |row, i| {
            for (row, 0..) |pile, j| {
                if (pile >= 4) {
                    if (i > 0) {
                        a.piles[i - 1][j] += 1;
                    }
                    if (i < 2) {
                        a.piles[i + 1][j] += 1;
                    }
                    if (j > 0) {
                        a.piles[i][j - 1] += 1;
                    }
                    if (j < 2) {
                        a.piles[i][j + 1] += 1;
                    }
                    a.piles[i][j] -= 4;
                }
            }
        }
        return Box.init(a.piles);
    }

    fn add(self: *const Box, other: *const Box) Box {
        var b = Box{
            .piles = [_][3]u8{[_]u8{0} ** 3} ** 3,
        };
        for (0..3) |row| {
            for (0..3) |col| {
                b.piles[row][col] = self.piles[row][col] + other.piles[row][col];
            }
        }
        return Box.init(b.piles);
    }
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("The piles demonstration avalanche starts as:\n{any}\n{any}\n{any}\n", .{
        [_]u8{ 4, 3, 3 },
        [_]u8{ 3, 1, 2 },
        [_]u8{ 0, 2, 3 },
    });

    const s0 = Box.init([_][3]u8{
        [_]u8{ 4, 3, 3 },
        [_]u8{ 3, 1, 2 },
        [_]u8{ 0, 2, 3 },
    });

    try stdout.print("And ends as:\n{any}\n{any}\n{any}\n", .{
        s0.piles[0],
        s0.piles[1],
        s0.piles[2],
    });

    const s1 = Box.init([_][3]u8{
        [_]u8{ 1, 2, 0 },
        [_]u8{ 2, 1, 1 },
        [_]u8{ 0, 1, 3 },
    });

    const s2 = Box.init([_][3]u8{
        [_]u8{ 2, 1, 3 },
        [_]u8{ 1, 0, 1 },
        [_]u8{ 0, 1, 0 },
    });

    const s1_2 = s1.add(&s2);
    const s2_1 = s2.add(&s1);

    try stdout.print("The piles in s1 + s2 are:\n{any}\n{any}\n{any}\n", .{
        s1_2.piles[0],
        s1_2.piles[1],
        s1_2.piles[2],
    });

    try stdout.print("The piles in s2 + s1 are:\n{any}\n{any}\n{any}\n", .{
        s2_1.piles[0],
        s2_1.piles[1],
        s2_1.piles[2],
    });

    const s3 = Box.init([_][3]u8{[_]u8{3} ** 3} ** 3);
    const s3_id = Box.init([_][3]u8{
        [_]u8{ 2, 1, 2 },
        [_]u8{ 1, 0, 1 },
        [_]u8{ 2, 1, 2 },
    });

    const s4 = s3.add(&s3_id);

    try stdout.print("The piles in s3 + s3_id are:\n{any}\n{any}\n{any}\n", .{
        s4.piles[0],
        s4.piles[1],
        s4.piles[2],
    });

    const s5 = s3_id.add(&s3_id);

    try stdout.print("The piles in s3_id + s3_id are:\n{any}\n{any}\n{any}\n", .{
        s5.piles[0],
        s5.piles[1],
        s5.piles[2],
    });
}
