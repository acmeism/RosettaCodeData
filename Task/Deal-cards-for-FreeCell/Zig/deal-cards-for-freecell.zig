const std = @import("std");

const Card = struct {
    value: u6 = 0,

    pub fn print(card: Card) void {
        const n: u8 = switch (card.value >> 2) {
            0 => 'A',
            1 => '2',
            2 => '3',
            3 => '4',
            4 => '5',
            5 => '6',
            6 => '7',
            7 => '8',
            8 => '9',
            9 => 'T',
            10 => 'J',
            11 => 'Q',
            12 => 'K',
            else => unreachable,
        };
        const s: u21 = switch (card.value & 0x3) {
            0 => '\u{2663}', // Club
            1 => '\u{2666}', // Diamond
            2 => '\u{2665}', // Heart
            3 => '\u{2660}', // Spade
            else => unreachable,
        };
        std.debug.print("{c}{u} ", .{ n, s });
    }
};

const Rand = struct {
    seed: u31 = 0,
    pub fn seed(rand: *Rand, value: u31) void {
        rand.seed = value;
    }

    pub fn next(rand: *Rand) u16 {
        const new_seed = rand.seed *% 214013 +% 2531011;
        rand.seed = new_seed;
        return @truncate(new_seed >> 16);
    }
};

pub fn deal(n: u31) void {
    const print = std.debug.print;
    var buffer: [52]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    var deck = std.ArrayListUnmanaged(Card).initCapacity(allocator, 52) catch unreachable;
    var card: Card = .{};

    while (card.value < 52) : (card.value += 1) {
        deck.appendAssumeCapacity(card);
    }

    var col: usize = 0;
    var rand = Rand{ .seed = n };
    print("Deal {d}:\n", .{n});
    while (deck.items.len > 0) {
        card = deck.swapRemove(rand.next() % deck.items.len);
        card.print();
        col = (col + 1) % 8;
        if (col == 0)
            print("\n", .{});
    }
    print("\n\n", .{});
}

pub fn main() !void {
    deal(1);
    deal(617);
}
