const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_writer = std.Io.File.stdout().writer(init.io, &.{});
    const stdout = &stdout_writer.interface;

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
