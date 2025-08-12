const std = @import("std");

const Fraction = struct {
    numerator: u32,
    denominator: u32,

    pub fn new(n: u32, d: u32) Fraction {
        return Fraction{
            .numerator = n,
            .denominator = d,
        };
    }

    pub fn format(
        self: Fraction,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        try writer.print("{d}/{d}", .{ self.numerator, self.denominator });
    }
};

const FareySequence = struct {
    a: u32,
    b: u32,
    c: u32,
    d: u32,
    n: u32,
    done: bool,

    pub fn init(n: u32) FareySequence {
        return FareySequence{
            .a = 0,
            .b = 1,
            .c = 1,
            .d = n,
            .n = n,
            .done = false,
        };
    }

    pub fn next(self: *FareySequence) ?Fraction {
        if (self.done) return null;
        if (self.a > self.n) {
            self.done = true;
            return null;
        }

        const result = Fraction.new(self.a, self.b);
        const k = (self.n + self.b) / self.d;
        const next_c = k * self.c - self.a;
        const next_d = k * self.d - self.b;
        self.a = self.c;
        self.b = self.d;
        self.c = next_c;
        self.d = next_d;
        return result;
    }

    pub fn count(self: *FareySequence) usize {
        var counter: usize = 0;
        while (self.next()) |_| {
            counter += 1;
        }
        return counter;
    }
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // Print Farey sequences for n=1 to n=11
    var n: u32 = 1;
    while (n <= 11) : (n += 1) {
        try stdout.print("{d}:", .{n});
        var seq = FareySequence.init(n);
        while (seq.next()) |fraction| {
            try stdout.print(" {}", .{fraction});
        }
        try stdout.print("\n", .{});
    }

    // Print counts for n=100 to n=1000 in steps of 100
    n = 100;
    while (n <= 1000) : (n += 100) {
        var seq = FareySequence.init(n);
        try stdout.print("{d}: {d}\n", .{ n, seq.count() });
    }
}
