const std = @import("std");
const stdout = std.io.getStdOut().outStream();

var board = [_]i8{-1} ** 8;

inline fn abs(x: var) @TypeOf(x) {
    return if (x < 0) -x else x;
}

fn safe(c: i32, r: i32) bool {
    var i: i32 = 0;
    return while (i < c) : (i += 1) {
        const q = board[@intCast(u3, i)];
        if (r == q or c == i + abs(q - r))
            break false;
    } else true;
}

pub fn main() !void {
    var i: i32 = 0;
    while (i >= 0) {
        var j = board[@intCast(u3, i)] + 1;
        while (j < 8) : (j += 1) {
            if (safe(i, j)) {
                board[@intCast(u3, i)] = j;
                i += 1;
                break;
            }
        } else {
            board[@intCast(u3, i)] = -1;
            i -= 1;
        }
        if (i == 8) { // found a solution
            for (board) |q|
                try stdout.print("{} ", .{q + 1});
            try stdout.print("\n", .{});
            i -= 1; // create a failure to try new solutions.
        }
    }
}
