fn f(n: u64) u64 {
    return if (n == 0) 1 else n-m(f(n-1));
}

fn m(n: u64) u64 {
    return if (n == 0) 0 else n-f(m(n-1));
}

pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();
    try stdout.writeAll(" n   F  M\n");
    for (0..20) |n| {
        try stdout.print("{d: >2}: {d: >2} {d: >2}\n", .{n, f(n), m(n)});
    }
}
