pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.writeAll("Police  Sanitation  Fire\n");
    try stdout.writeAll("------  ----------  ----\n");

    var it = SolutionIterator{};
    while (it.next()) |solution| {
        try stdout.print(
            "  {d}         {d}         {d}\n",
            .{ solution.police, solution.sanitation, solution.fire },
        );
    }
}
