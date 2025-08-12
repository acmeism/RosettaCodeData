const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const ParseError = error{
    InvalidAddress,
    InvalidValue,
    InvalidHexValue,
    OutOfMemory,
};

const ParseResult = struct {
    hex_address: []const u8,
    port: []const u8,

    fn deinit(self: ParseResult, allocator: Allocator) void {
        allocator.free(self.hex_address);
        allocator.free(self.port);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const tests = [_][]const u8{
        "192.168.0.1",
        "127.0.0.1",
        "256.0.0.1",
        "127.0.0.1:80",
        "::1",
        "[::1]:80",
        "[32e::12f]:80",
        "2605:2700:0:3::4713:93e3",
        "[2605:2700:0:3::4713:93e3]:80",
        "2001:db8:85a3:0:0:8a2e:370:7334"
    };

    print("{s:<40} {s:<32}   {s}\n", .{ "Test Case", "Hex Address", "Port" });

    for (tests) |ip| {
        const result = parseIP(allocator, ip) catch |err| {
            const error_msg = switch (err) {
                ParseError.InvalidAddress => "Unknown address",
                ParseError.InvalidValue => "Invalid value",
                ParseError.InvalidHexValue => "Invalid hex value",
                else => "Parse error",
            };
            print("{s:<40} Invalid address:  {s}\n", .{ ip, error_msg });
            continue;
        };
        defer result.deinit(allocator);

        print("{s:<40} {s:<32}   {s}\n", .{ ip, result.hex_address, result.port });
    }
}

fn parseIP(allocator: Allocator, ip: []const u8) !ParseResult {
    // Try IPv4 first
    if (parseIPv4(allocator, ip)) |result| {
        return result;
    } else |_| {}

    // Try IPv6 with double colon
    if (parseIPv6DoubleColon(allocator, ip)) |result| {
        return result;
    } else |_| {}

    // Try regular IPv6
    if (parseIPv6(allocator, ip)) |result| {
        return result;
    } else |_| {}

    return ParseError.InvalidAddress;
}

fn parseIPv4(allocator: Allocator, ip: []const u8) !ParseResult {
    var parts = std.mem.splitSequence(u8, ip, ".");
    var octets: [4]u8 = undefined;
    var port_str: []const u8 = "";
    var i: usize = 0;

    while (parts.next()) |part| {
        if (i >= 4) return ParseError.InvalidAddress;

        // Check if this part contains a port (last octet with colon)
        if (i == 3) {
            if (std.mem.indexOf(u8, part, ":")) |colon_pos| {
                const octet_str = part[0..colon_pos];
                port_str = part[colon_pos + 1..];

                const octet = std.fmt.parseInt(u8, octet_str, 10) catch return ParseError.InvalidValue;
                octets[i] = octet;
            } else {
                const octet = std.fmt.parseInt(u8, part, 10) catch return ParseError.InvalidValue;
                octets[i] = octet;
            }
        } else {
            const octet = std.fmt.parseInt(u8, part, 10) catch return ParseError.InvalidValue;
            octets[i] = octet;
        }
        i += 1;
    }

    if (i != 4) return ParseError.InvalidAddress;

    // Convert to hex
    var hex = ArrayList(u8).init(allocator);
    defer hex.deinit();

    for (octets) |octet| {
        try hex.writer().print("{x:0>2}", .{octet});
    }

    const port_copy = try allocator.dupe(u8, port_str);

    return ParseResult{
        .hex_address = try hex.toOwnedSlice(),
        .port = port_copy,
    };
}

fn parseIPv6DoubleColon(allocator: Allocator, ip: []const u8) !ParseResult {
    var working_ip = ip;
    var port_str: []const u8 = "";

    // Handle brackets and port
    if (std.mem.startsWith(u8, working_ip, "[")) {
        if (std.mem.lastIndexOf(u8, working_ip, "]:")) |bracket_pos| {
            port_str = working_ip[bracket_pos + 2..];
            working_ip = working_ip[1..bracket_pos];
        } else if (std.mem.endsWith(u8, working_ip, "]")) {
            working_ip = working_ip[1..working_ip.len - 1];
        }
    }

    // Check if it contains ::
    const double_colon_pos = std.mem.indexOf(u8, working_ip, "::") orelse return ParseError.InvalidAddress;

    const p1 = working_ip[0..double_colon_pos];
    const p2 = working_ip[double_colon_pos + 2..];

    const p1_count = if (p1.len == 0) 0 else countColons(p1) + 1;
    const p2_count = if (p2.len == 0) 0 else countColons(p2) + 1;

    const zeros_needed = 8 - p1_count - p2_count;

    // Reconstruct the full IPv6 address
    var full_ip = ArrayList(u8).init(allocator);
    defer full_ip.deinit();

    if (p1.len > 0) {
        try full_ip.appendSlice(p1);
        try full_ip.append(':');
    }

    for (0..zeros_needed) |_| {
        try full_ip.appendSlice("0:");
    }

    if (p2.len > 0) {
        try full_ip.appendSlice(p2);
    } else {
        // Remove trailing colon if p2 is empty
        if (full_ip.items.len > 0 and full_ip.items[full_ip.items.len - 1] == ':') {
            _ = full_ip.pop();
        }
    }

    const reconstructed = try full_ip.toOwnedSlice();
    defer allocator.free(reconstructed);

    return parseIPv6WithPort(allocator, reconstructed, port_str);
}

fn parseIPv6(allocator: Allocator, ip: []const u8) !ParseResult {
    return parseIPv6WithPort(allocator, ip, "");
}

fn parseIPv6WithPort(allocator: Allocator, ip: []const u8, port_override: []const u8) !ParseResult {
    var working_ip = ip;
    var port_str = port_override;

    // Handle brackets and port if not overridden
    if (port_override.len == 0) {
        if (std.mem.startsWith(u8, working_ip, "[")) {
            if (std.mem.lastIndexOf(u8, working_ip, "]:")) |bracket_pos| {
                port_str = working_ip[bracket_pos + 2..];
                working_ip = working_ip[1..bracket_pos];
            } else if (std.mem.endsWith(u8, working_ip, "]")) {
                working_ip = working_ip[1..working_ip.len - 1];
            }
        }
    }

    var parts = std.mem.splitSequence(u8, working_ip, ":");
    var groups: [8][]const u8 = undefined;
    var i: usize = 0;

    while (parts.next()) |part| {
        if (i >= 8) return ParseError.InvalidAddress;
        groups[i] = part;
        i += 1;
    }

    if (i != 8) return ParseError.InvalidAddress;

    // Convert to hex
    var hex = ArrayList(u8).init(allocator);
    defer hex.deinit();

    for (groups) |group| {
        if (group.len == 0) {
            try hex.appendSlice("0000");
        } else {
            // Validate hex and pad to 4 digits
            const val = std.fmt.parseInt(u16, group, 16) catch return ParseError.InvalidHexValue;
            try hex.writer().print("{x:0>4}", .{val});
        }
    }

    const port_copy = try allocator.dupe(u8, port_str);

    return ParseResult{
        .hex_address = try hex.toOwnedSlice(),
        .port = port_copy,
    };
}

fn countColons(s: []const u8) usize {
    var count: usize = 0;
    for (s) |c| {
        if (c == ':') count += 1;
    }
    return count;
}
