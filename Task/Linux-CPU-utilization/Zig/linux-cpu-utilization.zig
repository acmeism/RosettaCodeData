const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const CpuUtilization = struct {
    idle: f64,
    not_idle: f64,
};

const ParseError = error{
    InvalidFormat,
    ZeroTotal,
    ParseIntError,
};

const AppError = ParseError || std.fs.File.OpenError || std.fs.File.ReadError || std.mem.Allocator.Error;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    run(allocator) catch |err| {
        print("Error: {}\n", .{err});
        return;
    };
}

fn run(allocator: Allocator) !void {
    const proc_stat_line = try procStat(allocator);
    defer allocator.free(proc_stat_line);

    const percentages = try parseUtilization(proc_stat_line);

    print("{s:<10} {d:.2}%\n", .{ "idle", percentages.idle * 100.0 });
    print("{s:<10} {d:.2}%\n", .{ "not-idle", percentages.not_idle * 100.0 });
}

fn procStat(allocator: Allocator) ![]u8 {
    const file = try std.fs.openFileAbsolute("/proc/stat", .{});
    defer file.close();

    const data = try file.readToEndAlloc(allocator, 4096);
    defer allocator.free(data);

    // Find the first line (up to newline)
    var lines = std.mem.splitSequence(u8, data, "\n");
    const first_line = lines.next() orelse "";

    return try allocator.dupe(u8, first_line);
}

/// Parse the /proc/stat line to extract CPU utilization percentages
///
/// Arguments:
/// * `line` - The first line from /proc/stat
///
/// Returns:
/// A struct containing idle and not_idle percentages
fn parseUtilization(line: []const u8) !CpuUtilization {
    // Remove "cpu " prefix and trim whitespace
    const values_str = if (std.mem.startsWith(u8, line, "cpu "))
        std.mem.trimLeft(u8, line[4..], " ")
    else
        std.mem.trimLeft(u8, line, " ");

    var total: u64 = 0;
    var idle: u64 = 0;

    var iter = std.mem.splitSequence(u8, values_str, " ");
    var index: usize = 0;

    while (iter.next()) |value_str| {
        if (value_str.len == 0) continue;

        const num = std.fmt.parseInt(u64, value_str, 10) catch |err| switch (err) {
            error.InvalidCharacter, error.Overflow => return ParseError.ParseIntError,
        };

        if (index == 3) {
            idle = num;
        }
        total += num;
        index += 1;
    }

    if (total == 0) {
        return ParseError.ZeroTotal;
    }

    const idle_percentage = @as(f64, @floatFromInt(idle)) / @as(f64, @floatFromInt(total));
    const not_idle_percentage = 1.0 - idle_percentage;

    return CpuUtilization{
        .idle = idle_percentage,
        .not_idle = not_idle_percentage,
    };
}
