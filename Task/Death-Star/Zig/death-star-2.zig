pub fn main() !void {
    // buffer stdout --------------------------------------
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    // allocator ------------------------------------------
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const ok = gpa.deinit();
        std.debug.assert(ok == .ok);
    }
    const allocator = gpa.allocator();

    // deathstar ------------------------------------------
    var dstar = try DeathStar(f32).init(allocator);
    defer dstar.deinit();

    // print deathstar PGM to stdout ----------------------
    const comments = [_][]const u8{
        "Rosetta Code",
        "DeathStar",
        "https://rosettacode.org/wiki/Death_Star",
    };
    try dstar.print(stdout, comments[0..]);

    // ----------------------------------------------------
    try bw.flush();
}
