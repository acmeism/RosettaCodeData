const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const SUITS = [_][]const u8{ "♣", "♦", "♥", "♠" };
const FACES = [_][]const u8{ "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A" };

const Card = struct {
    display: [4]u8,
    rank: usize,

    fn new(index: usize) Card {
        const face = FACES[index % 13];
        const suit = SUITS[index / 13];

        var display: [4]u8 = undefined;
        // Copy face (1 byte)
        display[0] = face[0];
        // Copy suit (3 bytes for Unicode symbols)
        @memcpy(display[1..4], suit[0..3]);

        return Card{
            .display = display,
            .rank = index % 13,
        };
    }

    fn getDisplaySlice(self: *const Card) []const u8 {
        return self.display[0..4];
    }
};

fn war(allocator: Allocator) !void {
    // Create and shuffle deck
    var deck = ArrayList(usize).init(allocator);
    defer deck.deinit();

    for (0..52) |i| {
        try deck.append(i);
    }

    // Shuffle deck
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        std.posix.getrandom(std.mem.asBytes(&seed)) catch @panic("Failed to get random seed");
        break :blk seed;
    });
    const random = prng.random();
    random.shuffle(usize, deck.items);

    // Deal cards to players (reversing order to match original implementation)
    var hand1 = ArrayList(usize).init(allocator);
    defer hand1.deinit();
    var hand2 = ArrayList(usize).init(allocator);
    defer hand2.deinit();

    try hand1.ensureTotalCapacity(52);
    try hand2.ensureTotalCapacity(52);

    for (0..26) |i| {
        try hand1.append(deck.items[2 * i]);
        try hand2.append(deck.items[2 * i + 1]);
    }

    // Reverse hands
    std.mem.reverse(usize, hand1.items);
    std.mem.reverse(usize, hand2.items);

    // Create cards lookup
    var cards: [52]Card = undefined;
    for (0..52) |i| {
        cards[i] = Card.new(i);
    }

    while (hand1.items.len > 0 and hand2.items.len > 0) {
        const card1 = hand1.orderedRemove(0);
        const card2 = hand2.orderedRemove(0);

        var played1 = ArrayList(usize).init(allocator);
        defer played1.deinit();
        var played2 = ArrayList(usize).init(allocator);
        defer played2.deinit();

        try played1.append(card1);
        try played2.append(card2);
        var num_played: usize = 2;

        var current_card1 = card1;
        var current_card2 = card2;

        while (true) {
            print("{s}\t{s}\t",   .{cards[current_card1].getDisplaySlice(), cards[current_card2].getDisplaySlice()}  );

            if (cards[current_card1].rank > cards[current_card2].rank) {
                try hand1.appendSlice(played1.items);
                try hand1.appendSlice(played2.items);
                print("Player 1 takes the {} cards. Now has {}.\n", .{ num_played, hand1.items.len });
                break;
            } else if (cards[current_card1].rank < cards[current_card2].rank) {
                try hand2.appendSlice(played2.items);
                try hand2.appendSlice(played1.items);
                print("Player 2 takes the {} cards. Now has {}.\n", .{ num_played, hand2.items.len });
                break;
            } else {
                print("War!\n", .{});

                if (hand1.items.len < 2) {
                    print("Player 1 has insufficient cards left.\n", .{});
                    try hand2.appendSlice(played2.items);
                    try hand2.appendSlice(played1.items);
                    try hand2.appendSlice(hand1.items);
                    hand1.clearRetainingCapacity();
                    break;
                }

                if (hand2.items.len < 2) {
                    print("Player 2 has insufficient cards left.\n", .{});
                    try hand1.appendSlice(played1.items);
                    try hand1.appendSlice(played2.items);
                    try hand1.appendSlice(hand2.items);
                    hand2.clearRetainingCapacity();
                    break;
                }

                const fd_card1 = hand1.orderedRemove(0); // face down card
                current_card1 = hand1.orderedRemove(0); // face up card
                try played1.append(fd_card1);
                try played1.append(current_card1);

                const fd_card2 = hand2.orderedRemove(0); // face down card
                current_card2 = hand2.orderedRemove(0); // face up card
                try played2.append(fd_card2);
                try played2.append(current_card2);

                num_played += 4;
                print("? \t? \tFace down cards.\n" , .{});
            }
        }
    }

    if (hand1.items.len == 52) {
        print("Player 1 wins the game!\n", .{});
    } else {
        print("Player 2 wins the game!\n", .{});
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    try war(allocator);
}
