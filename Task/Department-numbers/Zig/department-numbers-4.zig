pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    _ = try stdout.writeAll("Police  Sanitation  Fire\n");
    _ = try stdout.writeAll("------  ----------  ----\n");

    var it = SolutionIterator{};
    while (it.next()) |solution| {
        _ = try stdout.print(
            "  {d}         {d}         {d}\n",
            .{ solution.police, solution.sanitation, solution.fire },
        );
    }
}
