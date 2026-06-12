const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const GEO_BASE_32 = "0123456789bcdefghjkmnpqrstuvwxyz";

const Range = struct {
    lower: f64,
    upper: f64,

    fn init(lower: f64, upper: f64) Range {
        return Range{ .lower = lower, .upper = upper };
    }
};

const Location = struct {
    latitude: f64,
    longitude: f64,

    fn init(latitude: f64, longitude: f64) Location {
        return Location{ .latitude = latitude, .longitude = longitude };
    }

    fn format(self: Location, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;
        _ = options;
        const sector_sn = if (self.latitude < 0.0) " S" else " N";
        const sector_we = if (self.longitude < 0.0) " W" else " E";
        try writer.print("({d}{s}, {d}{s})", .{ self.latitude, sector_sn, self.longitude, sector_we });
    }
};

fn encodeGeohash(allocator: Allocator, location: Location, precision: u32) ![]u8 {
    var latitude_range = Range.init(-90.0, 90.0);
    var longitude_range = Range.init(-180.0, 180.0);
    var geohash = ArrayList(u8).init(allocator);
    defer geohash.deinit();

    var geohash_value: u32 = 0;
    var bit_count: u32 = 0;
    var even = true;

    while (geohash.items.len < precision) {
        const value = if (even) location.longitude else location.latitude;
        const range = if (even) longitude_range else latitude_range;
        const mid_range = (range.lower + range.upper) / 2.0;

        if (value > mid_range) {
            geohash_value = (geohash_value << 1) + 1;
            if (even) {
                longitude_range = Range.init(mid_range, longitude_range.upper);
            } else {
                latitude_range = Range.init(mid_range, latitude_range.upper);
            }
        } else {
            geohash_value <<= 1;
            if (even) {
                longitude_range = Range.init(longitude_range.lower, mid_range);
            } else {
                latitude_range = Range.init(latitude_range.lower, mid_range);
            }
        }

        even = !even;
        if (bit_count < 4) {
            bit_count += 1;
        } else {
            bit_count = 0;
            if (geohash_value < GEO_BASE_32.len) {
                try geohash.append(GEO_BASE_32[geohash_value]);
            }
            geohash_value = 0;
        }
    }

    return geohash.toOwnedSlice();
}

fn findCharInString(haystack: []const u8, needle: u8) ?usize {
    for (haystack, 0..) |char, i| {
        if (char == needle) return i;
    }
    return null;
}

fn decodeGeohash(allocator: Allocator, geohash: []const u8) ![]u8 {
    var latitude_range = Range.init(-90.0, 90.0);
    var longitude_range = Range.init(-180.0, 180.0);
    var even = true;

    for (geohash) |ch| {
        if (findCharInString(GEO_BASE_32, ch)) |position| {
            // Convert position to 5-bit binary
            var bit_mask: u8 = 0b10000; // Start with the most significant bit
            var i: u8 = 0;
            while (i < 5) : (i += 1) {
                const mid_range = if (even)
                    (longitude_range.lower + longitude_range.upper) / 2.0
                else
                    (latitude_range.lower + latitude_range.upper) / 2.0;

                const bit_set = (@as(u8, @intCast(position)) & bit_mask) != 0;

                if (!bit_set) {
                    if (even) {
                        longitude_range = Range.init(longitude_range.lower, mid_range);
                    } else {
                        latitude_range = Range.init(latitude_range.lower, mid_range);
                    }
                } else {
                    if (even) {
                        longitude_range = Range.init(mid_range, longitude_range.upper);
                    } else {
                        latitude_range = Range.init(mid_range, latitude_range.upper);
                    }
                }
                even = !even;
                bit_mask >>= 1;
            }
        }
    }

    const latitude_error = @abs(latitude_range.lower - latitude_range.upper);
    const longitude_error = @abs(longitude_range.lower - longitude_range.upper);
    const max_error = @max(latitude_error, longitude_error);
    const mid_latitude = (latitude_range.lower + latitude_range.upper) / 2.0;
    const mid_longitude = (longitude_range.lower + longitude_range.upper) / 2.0;
    const sector_sn = if (mid_latitude < 0.0) " S" else " N";
    const sector_we = if (mid_longitude < 0.0) " W" else " E";

    return std.fmt.allocPrint(allocator, "({d:.15}{s}, {d:.15}{s}) ± {d:.15}", .{
        mid_latitude, sector_sn, mid_longitude, sector_we, max_error
    });
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const locations = [_]Location{
        Location.init(51.433718, -0.214126),
        Location.init(51.433718, -0.214126),
        Location.init(57.64911, 10.40744),
        Location.init(57.64911, 10.40744),
    };
    const precisions = [_]u32{ 2, 9, 11, 21 };

    var test_results = ArrayList([]u8).init(allocator);
    defer {
        for (test_results.items) |result| {
            allocator.free(result);
        }
        test_results.deinit();
    }

    for (locations, precisions) |location, precision| {
        const geohash = try encodeGeohash(allocator, location, precision);
        try test_results.append(geohash);
        print("geohash for {} with precision {:2} => {s}\n", .{ location, precision, geohash });
    }
    print("\n", .{});

    for (test_results.items) |test_result| {
        const decoded = try decodeGeohash(allocator, test_result);
        defer allocator.free(decoded);
        print("{s:<21} => {s}\n", .{ test_result, decoded });
    }
}
