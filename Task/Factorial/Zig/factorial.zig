const stdout = @import("std").io.getStdOut().outStream();

pub fn factorial(comptime Num: type, n: i8) ?Num {
    return if (@typeInfo(Num) != .Int)
        @compileError("factorial called with num-integral type: " ++ @typeName(Num))
    else if (n < 0)
        null
    else calc: {
        var i: i8 = 1;
        var fac: Num = 1;
        while (i <= n) : (i += 1) {
            if (@mulWithOverflow(Num, fac, i, &fac))
                break :calc null;
        } else break :calc fac;
    };
}

pub fn main() !void {
    try stdout.print("-1! = {}\n", .{factorial(i32, -1)});
    try stdout.print("0! = {}\n", .{factorial(i32, 0)});
    try stdout.print("5! = {}\n", .{factorial(i32, 5)});
    try stdout.print("33!(64 bit) = {}\n", .{factorial(i64, 33)}); // not vailid i64 factorial
    try stdout.print("33! = {}\n", .{factorial(i128, 33)}); // biggest facorial possible
    try stdout.print("34! = {}\n", .{factorial(i128, 34)}); // will overflow
}
