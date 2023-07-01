pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();

    var square: u8 = 1;
    var increment: u8 = 3;
    var door: u8 = 1;
    while (door <= 100) : (door += 1) {
        if (door == square) {
            try stdout.print("Door {d} is open\n", .{door});
            square += increment;
            increment += 2;
        }
    }
}
