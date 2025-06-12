const std = @import("std");

const Ipv4Cidr = struct {
    address: u32,
    mask_length: u8,

    pub fn parse(s: []const u8) !Ipv4Cidr {
        var split = std.mem.splitSequence(u8, s, "/");
        const addr_str = split.first();
        const mask_str = split.next() orelse return error.InvalidFormat;
        if (split.next() != null) return error.InvalidFormat;

        var octets: [4]u8 = undefined;
        var addr_split = std.mem.splitSequence(u8, addr_str, ".");
        for (0..4) |i| {
            const part = addr_split.next() orelse return error.InvalidFormat;
            octets[i] = std.fmt.parseInt(u8, part, 10) catch return error.InvalidFormat;
        }
        if (addr_split.next() != null) return error.InvalidFormat;

        const address = (@as(u32, octets[0]) << 24) |
                        (@as(u32, octets[1]) << 16) |
                        (@as(u32, octets[2]) << 8)  |
                         octets[3];

        const mask_length = std.fmt.parseInt(u8, mask_str, 10) catch return error.InvalidFormat;
        if (mask_length < 1 or mask_length > 32) return error.InvalidMask;

        const shift = @as(u5, @intCast(32 - mask_length));
        const mask = ~((@as(u32, 1) << shift) - 1);
        const masked_address = address & mask;

        return Ipv4Cidr{
            .address = masked_address,
            .mask_length = mask_length,
        };
    }

    pub fn format(
        self: Ipv4Cidr,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        const a = (self.address >> 24) & 0xFF;
        const b = (self.address >> 16) & 0xFF;
        const c = (self.address >> 8) & 0xFF;
        const d = self.address & 0xFF;
        try writer.print("{}.{}.{}.{}/{}", .{a, b, c, d, self.mask_length});
    }
};

pub fn main() !void {
    const tests = [_][]const u8{
        "87.70.141.1/22",
        "36.18.154.103/12",
        "62.62.197.11/29",
        "67.137.119.181/4",
        "161.214.74.21/24",
        "184.232.176.184/18",
    };

    for (tests) |my_test| {
        const cidr = Ipv4Cidr.parse(my_test) catch |err| {
            std.debug.print("{s}: invalid CIDR ({s})\n", .{my_test, @errorName(err)});
            continue;
        };
        std.debug.print("{s:<18} -> {}\n", .{my_test, cidr});
    }
}
