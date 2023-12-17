const std = @import("std");

pub fn main() void {
    const dog = "Benjamin";
    const Dog = "Samba";
    const DOG = "Bernie";

    std.debug.print("The three dogs are named {s}, {s}, and {s}.\n", .{ dog, Dog, DOG });
}
