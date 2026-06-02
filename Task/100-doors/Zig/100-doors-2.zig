const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_writer = std.Io.File.stdout().writer(init.io, &.{});
    const stdout = &stdout_writer.interface;

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
