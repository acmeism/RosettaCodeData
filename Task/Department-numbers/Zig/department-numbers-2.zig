pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    _ = try stdout.writeAll("Police  Sanitation  Fire\n");
    _ = try stdout.writeAll("------  ----------  ----\n");

    var p: usize = 2;
    while (p <= 7) : (p += 2)
        for (1..7 + 1) |s|
            for (1..7 + 1) |f|
                if (p != s and s != f and f != p and p + f + s == 12) {
                    _ = try stdout.print("  {d}         {d}         {d}\n", .{ p, s, f });
                };
}
