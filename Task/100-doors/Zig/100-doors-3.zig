const stdout = @import("std").io.getStdOut().writer();

pub fn main() !void {
    var square: u8 = 1;
    var increment: u8 = 3;
    for (1..101) |door| {
        if (door == square) {
            try stdout.print("Door {d} is open\n", .{door});
            square += increment;
            increment += 2;
        }
    }
}
