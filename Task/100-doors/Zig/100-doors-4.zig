pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();

    var door: u8 = 1;
    while (door * door <= 100) : (door += 1) {
        try stdout.print("Door {d} is open\n", .{door * door});
    }
}
