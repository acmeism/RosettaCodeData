const stdout = @import("std").io.getStdOut().writer();

pub fn main() !void {
    var i: u128 = 1;

    while (true) : (i += 1) {
        try stdout.print("{}, ", .{i});
    }
}
