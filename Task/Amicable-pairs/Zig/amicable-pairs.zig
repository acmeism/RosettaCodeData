const MAXIMUM: u32 = 20_000;

// Fill up a given array with arr[n] = sum(propDivs(n))
pub fn calcPropDivs(divs: []u32) void {
    for (divs) |*d| d.* = 1;
    var i: u32 = 2;
    while (i <= divs.len/2) : (i += 1) {
        var j = i * 2;
        while (j < divs.len) : (j += i)
            divs[j] += i;
    }
}

// Are (A, B) an amicable pair?
pub fn amicable(divs: []const u32, a: u32, b: u32) bool {
    return divs[a] == b and a == divs[b];
}

pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();

    var divs: [MAXIMUM + 1]u32 = undefined;
    calcPropDivs(divs[0..]);

    var a: u32 = 1;
    while (a < divs.len) : (a += 1) {
        var b = a+1;
        while (b < divs.len) : (b += 1) {
            if (amicable(divs[0..], a, b))
                try stdout.print("{d}, {d}\n", .{a, b});
        }
    }
}
