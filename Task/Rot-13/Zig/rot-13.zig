const std = @import("std");

pub const Rot13 = struct {
    pub fn char(ch: u8) u8 {
        return switch (ch) {
            'a'...'m', 'A'...'M' => |c| c + 13,
            'n'...'z', 'N'...'Z' => |c| c - 13,
            else => |c| c,
        };
    }

    /// Caller owns returned memory.
    pub fn slice(allocator: std.mem.Allocator, input: []const u8) error{OutOfMemory}![]u8 {
        const output = try allocator.alloc(u8, input.len);
        errdefer allocator.free(output);

        for (input, output) |input_ch, *output_ch| {
            output_ch.* = char(input_ch);
        }

        return output;
    }
};

pub fn main() error{OutOfMemory}!void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const message_input =
        \\@@@111@@@ Lbh xabj vg vf tbvat gb or n onq qnl
        \\ jura gur yrggref va lbhe nycunorg fbhc
        \\ fcryy Q-V-F-N-F-G-R-E.
    ;
    const message_decoded = try Rot13.slice(allocator, message_input);
    defer allocator.free(message_decoded);

    std.debug.print(
        \\{s}
        \\=== Decoded to ===
        \\{s}
        \\
    , .{
        message_input,
        message_decoded,
    });

    std.debug.print("\n", .{});

    const message_encoded = try Rot13.slice(allocator, message_decoded);
    defer allocator.free(message_encoded);

    std.debug.print(
        \\{s}
        \\=== Encoded to ===
        \\{s}
        \\
    , .{
        message_decoded,
        message_encoded,
    });
}
