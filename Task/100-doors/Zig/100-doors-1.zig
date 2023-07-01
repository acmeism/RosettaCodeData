pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();

    var doors = [_]bool{false} ** 101;
    var pass: u8 = 1;
    var door: u8 = undefined;

    while (pass <= 100) : (pass += 1) {
        door = pass;
        while (door <= 100) : (door += pass)
            doors[door] = !doors[door];
    }

    for (doors, 0..) |open, num|
        if (open)
            try stdout.print("Door {d} is open.\n", .{num});
}
