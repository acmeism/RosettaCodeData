/// Degrees are not constrained to the range 0 to 360
fn degreesToCompassPoint(degrees: f32) []const u8 {
    var d = degrees + comptime (11.25 / 2.0);
    while (d < 0) d += 360;
    while (d >= 360) d -= 360;
    const index: usize = @floatToInt(usize, @divFloor(d, 11.25));

    // Concatenation to overcome the inability of "zig fmt" to nicely format long arrays.
    const points: [32][]const u8 = comptime .{} ++
        .{ "North", "North by east", "North-northeast", "Northeast by north" } ++
        .{ "Northeast", "Northeast by east", "East-northeast", "East by north" } ++
        .{ "East", "East by south", "East-southeast", "Southeast by east" } ++
        .{ "Southeast", "Southeast by south", "South-southeast", "South by east" } ++
        .{ "South", "South by west", "South-southwest", "Southwest by south" } ++
        .{ "Southwest", "Southwest by west", "West-southwest", "West by south" } ++
        .{ "West", "West by north", "West-northwest", "Northwest by west" } ++
        .{ "Northwest", "Northwest by north", "North-northwest", "North by west" };

    return points[index];
}
