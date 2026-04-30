const std = @import("std");
const print = std.debug.print;

pub fn jaro(s1: []const u8, s2: []const u8) f64 {
    const s1_len = s1.len;
    const s2_len = s2.len;

    if (s1_len == 0 and s2_len == 0) return 1.0;

    const match_distance = @max(s1_len, s2_len) / 2 - 1;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var s1_matches = allocator.alloc(bool, s1_len) catch return 0.0;
    var s2_matches = allocator.alloc(bool, s2_len) catch return 0.0;

    // Initialize arrays to false
    @memset(s1_matches, false);
    @memset(s2_matches, false);

    var m: i32 = 0;

    for (s1, 0..) |c1, i| {
        const start = if (i >= match_distance) i - match_distance else 0;
        const end = @min(i + match_distance + 1, s2_len);

        for (start..end) |j| {
            if (!s2_matches[j] and c1 == s2[j]) {
                s1_matches[i] = true;
                s2_matches[j] = true;
                m += 1;
                break;
            }
        }
    }

    if (m == 0) return 0.0;

    var t: f64 = 0.0;
    var k: usize = 0;

    for (s1, 0..) |c1, i| {
        if (s1_matches[i]) {
            while (!s2_matches[k]) k += 1;
            if (c1 != s2[k]) t += 0.5;
            k += 1;
        }
    }

    const m_f64 = @as(f64, @floatFromInt(m));
    const s1_len_f64 = @as(f64, @floatFromInt(s1_len));
    const s2_len_f64 = @as(f64, @floatFromInt(s2_len));

    return (m_f64 / s1_len_f64 + m_f64 / s2_len_f64 + (m_f64 - t) / m_f64) / 3.0;
}

pub fn main() void {
    const pairs = [_][2][]const u8{
        .{ "MARTHA", "MARHTA" },
        .{ "DIXON", "DICKSONX" },
        .{ "JELLYFISH", "SMELLYFISH" },
    };

    for (pairs) |pair| {
        print("{s}/{s} = {d:.6}\n", .{ pair[0], pair[1], jaro(pair[0], pair[1]) });
    }
}
