const std = @import("std");
const ArrayList = std.ArrayList;
const HashMap = std.StringHashMap;
const Allocator = std.mem.Allocator;

const Bacon = struct {
    b_alphabet: ArrayList([]u8),
    allocator: Allocator,

    fn init(allocator: Allocator) !Bacon {
        var b_alphabet = ArrayList([]u8).init(allocator);
        var x: u8 = 0;

        // First 9 letters (A-I)
        for (0..9) |_| {
            var buf = try allocator.alloc(u8, 5);
            for (0..5) |j| {
                buf[4 - j] = if ((x >> @intCast(j)) & 1 == 1) '1' else '0';
            }
            try b_alphabet.append(buf);
            x += 1;
        }
        // J shares code with I
        try b_alphabet.append(try allocator.dupe(u8, b_alphabet.items[b_alphabet.items.len - 1]));

        // Next 10 letters (K-T)
        for (10..20) |_| {
            var buf = try allocator.alloc(u8, 5);
            for (0..5) |j| {
                buf[4 - j] = if ((x >> @intCast(j)) & 1 == 1) '1' else '0';
            }
            try b_alphabet.append(buf);
            x += 1;
        }
        // U/V share code
        try b_alphabet.append(try allocator.dupe(u8, b_alphabet.items[b_alphabet.items.len - 1]));

        // Last 3 letters (W-Z)
        for (21..24) |_| {
            var buf = try allocator.alloc(u8, 5);
            for (0..5) |j| {
                buf[4 - j] = if ((x >> @intCast(j)) & 1 == 1) '1' else '0';
            }
            try b_alphabet.append(buf);
            x += 1;
        }

        return Bacon{ .b_alphabet = b_alphabet, .allocator = allocator };
    }

    fn deinit(self: *Bacon) void {
        for (self.b_alphabet.items) |item| {
            self.allocator.free(item);
        }
        self.b_alphabet.deinit();
    }

    fn encode(self: *const Bacon, allocator: Allocator, txt: []const u8) ![]u8 {
        var result = ArrayList(u8).init(allocator);

        for (txt) |c| {
            const z = std.ascii.toUpper(c);
            if (z < 'A' or z > 'Z') continue;

            const index = @as(usize, (z & 31) - 1);
            try result.appendSlice(self.b_alphabet.items[index]);
        }

        return result.toOwnedSlice();
    }

    fn decode(self: *const Bacon, allocator: Allocator, txt: []const u8) ![]u8 {
        var result = ArrayList(u8).init(allocator);
        var len = txt.len;

        while (len % 5 != 0) {
            len -= 1;
        }

        const valid_txt = txt[0..len];

        // Create a hashmap for the alphabet
        var alphabet_map = HashMap(usize).init(allocator);
        defer alphabet_map.deinit();

        for (self.b_alphabet.items, 0..) |item, i| {
            try alphabet_map.put(item, i);
        }

        var i: usize = 0;
        while (i < len) : (i += 5) {
            const substr = valid_txt[i..i+5];
            if (alphabet_map.get(substr)) |index| {
                try result.append('A' + @as(u8, @truncate(index)));
            }
        }

        return result.toOwnedSlice();
    }
};

const CipherI = struct {
    b: Bacon,
    allocator: Allocator,

    fn init(allocator: Allocator) !CipherI {
        return CipherI{
            .b = try Bacon.init(allocator),
            .allocator = allocator,
        };
    }

    fn deinit(self: *CipherI) void {
        self.b.deinit();
    }

    fn encode(self: *const CipherI, allocator: Allocator, txt: []const u8) ![]u8 {
        const encoded = try self.b.encode(allocator, txt);
        defer allocator.free(encoded);

        var result = ArrayList(u8).init(allocator);

        const d = "one morning, when gregor samsa woke from troubled dreams, he found himself transformed " ++
                 "in his bed into a horrible vermin. he lay on his armour-like back, and if he lifted his head a little he " ++
                 "could see his brown belly, slightly domed and divided by arches into stiff sections.";

        var r: usize = 0;
        for (encoded) |c| {
            var t = d[r];
            while (t < 'a' or t > 'z') {
                try result.append(t);
                r += 1;
                t = d[r];
            }
            r += 1;

            if (c == '1') {
                try result.append(std.ascii.toUpper(t));
            } else {
                try result.append(t);
            }
        }

        return result.toOwnedSlice();
    }

    fn decode(self: *const CipherI, allocator: Allocator, txt: []const u8) ![]u8 {
        var binary = ArrayList(u8).init(allocator);
        defer binary.deinit();

        for (txt) |c| {
            if ((c < 'a' and (c < 'A' or c > 'Z')) or c > 'z') {
                continue;
            }

            if (std.ascii.isLower(c)) {
                try binary.append('0');
            } else {
                try binary.append('1');
            }
        }

        return self.b.decode(allocator, binary.items);
    }
};

const CipherII = struct {
    b: Bacon,
    allocator: Allocator,

    fn init(allocator: Allocator) !CipherII {
        return CipherII{
            .b = try Bacon.init(allocator),
            .allocator = allocator,
        };
    }

    fn deinit(self: *CipherII) void {
        self.b.deinit();
    }

    fn encode(self: *const CipherII, allocator: Allocator, txt: []const u8) ![]u8 {
        const encoded = try self.b.encode(allocator, txt);
        defer allocator.free(encoded);

        var result = ArrayList(u8).init(allocator);

        for (encoded) |c| {
            if (c == '0') {
                // UTF-8 encoding of ù (0xf9)
                try result.append(0xC3);
                try result.append(0xB9);
            } else {
                // UTF-8 encoding of ú (0xfa)
                try result.append(0xC3);
                try result.append(0xBA);
            }
        }

        return result.toOwnedSlice();
    }

    fn decode(self: *const CipherII, allocator: Allocator, txt: []const u8) ![]u8 {
        var binary = ArrayList(u8).init(allocator);
        defer binary.deinit();

        var i: usize = 0;
        while (i < txt.len) {
            // Check for UTF-8 sequence
            if (i + 1 < txt.len and txt[i] == 0xC3) {
                if (txt[i + 1] == 0xB9) { // ù
                    try binary.append('0');
                } else { // ú
                    try binary.append('1');
                }
                i += 2;
            } else {
                i += 1;
            }
        }

        return self.b.decode(allocator, binary.items);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var c1 = try CipherI.init(allocator);
    defer c1.deinit();

    var c2 = try CipherII.init(allocator);
    defer c2.deinit();

    const s = "lets have some fun with bacon cipher";

    const h1 = try c1.encode(allocator, s);
    defer allocator.free(h1);

    const h2 = try c2.encode(allocator, s);
    defer allocator.free(h2);

    const d1 = try c1.decode(allocator, h1);
    defer allocator.free(d1);

    const d2 = try c2.decode(allocator, h2);
    defer allocator.free(d2);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}\n\n{s}\n\n", .{ h1, d1 });
    try stdout.print("{s}\n\n{s}\n\n", .{ h2, d2 });
}
