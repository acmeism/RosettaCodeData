pub fn beginsWith(a: u16, b: u16) bool {
    var aa = a;
    while (aa > b) aa /= 10;
    return aa == b;
}

pub fn smallestSquare(n: u16) u16 {
    var sqn: u16 = 1;
    while (true) : (sqn += 1) {
        var sq = sqn * sqn;
        if (beginsWith(sq, n)) return sq;
    }
}

pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();
    var n: u16 = 1;
    while (n < 50) : (n += 1) {
        try stdout.print("{d}\n", .{smallestSquare(n)});
    }
}
