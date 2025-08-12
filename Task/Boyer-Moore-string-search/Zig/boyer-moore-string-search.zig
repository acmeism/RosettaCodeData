const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

fn display(numbers: []const i32) void {
    print("[", .{});
    for (numbers, 0..) |num, i| {
        if (i > 0) {
            print(", ", .{});
        }
        print("{}", .{num});
    }
    print("]\n", .{});
}

fn stringSearchSingle(haystack: []const u8, needle: []const u8) i32 {
    if (std.mem.indexOf(u8, haystack, needle)) |index| {
        return @intCast(index);
    }
    return -1;
}

fn stringSearch(allocator: Allocator, haystack: []const u8, needle: []const u8) !ArrayList(i32) {
    var result = ArrayList(i32).init(allocator);
    var start: usize = 0;

    while (start < haystack.len) {
        const haystack_reduced = haystack[start..];
        const index = stringSearchSingle(haystack_reduced, needle);

        if (index >= 0) {
            try result.append(@as(i32, @intCast(start)) + index);
            start += @as(usize, @intCast(index)) + needle.len;
        } else {
            break;
        }
    }

    return result;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const texts = [_][]const u8{
        "GCTAGCTCTACGAGTCTA",
        "GGCTATAATGCGTA",
        "there would have been a time for such a word",
        "needle need noodle needle",
        "DKnuthusesandprogramsanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguages",
        "Nearby farms grew an acre of alfalfa on the dairy's behalf, with bales of that alfalfa exchanged for milk."
    };

    const patterns = [_][]const u8{"TCTA", "TAATAAA", "word", "needle", "and", "alfalfa"};

    for (texts, 0..) |text, i| {
        print("text{} = {s}\n", .{ i + 1, text });
    }
    print("\n" ,.{});

    for (texts, 0..) |text, i| {
        var indexes = try stringSearch(allocator, text, patterns[i]);
        defer indexes.deinit();

        print("Found \"{s}\" in 'text{}' at indexes ", .{ patterns[i], i + 1 });
        display(indexes.items);
    }
}
