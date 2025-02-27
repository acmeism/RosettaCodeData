pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();

    for(1..11) |door| {
        try stdout.print("Door {d} is open\n", .{door * door});
    }
}
