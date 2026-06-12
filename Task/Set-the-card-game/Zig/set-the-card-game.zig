const std = @import("std");

const numbers = [_][]const u8{ "ONE", "TWO", "THREE" };
const colours = [_][]const u8{ "GREEN", "RED", "PURPLE" };
const shadings = [_][]const u8{ "OPEN", "SOLID", "SRIPED" };
const shapes = [_][]const u8{ "DIAMOND", "OVAL", "SQUIGGLE" };

const Card = [4][]const u8;

fn createPackOfCards(allocator: std.mem.Allocator) !std.ArrayList(Card) {
    var pack = std.ArrayList(Card).init(allocator);

    for (numbers) |number| {
        for (colours) |colour| {
            for (shadings) |shading| {
                for (shapes) |shape| {
                    const card = [_][]const u8{ number, colour, shading, shape };
                    try pack.append(card);
                }
            }
        }
    }

    return pack;
}

fn allSameOrAllDifferent(triple: []const Card, index: usize) bool {
    var set = std.StringHashMap(void).init(std.heap.page_allocator);
    defer set.deinit();

    for (triple) |card| {
        set.put(card[index], {}) catch unreachable;
    }

    return set.count() == 1 or set.count() == 3;
}

fn isGameSet(triple: []const Card) bool {
    return allSameOrAllDifferent(triple, 0) and
           allSameOrAllDifferent(triple, 1) and
           allSameOrAllDifferent(triple, 2) and
           allSameOrAllDifferent(triple, 3);
}

fn generateCombinations(allocator: std.mem.Allocator, list: []const Card, choose: usize) !std.ArrayList([]const Card) {
    var combinations = std.ArrayList([]const Card).init(allocator);

    var combination = try allocator.alloc(usize, choose);
    defer allocator.free(combination);

    // Initialize with first combination
    for (0..choose) |i| {
        combination[i] = i;
    }

    while (combination[choose - 1] < list.len) {
        var entry = try allocator.alloc(Card, choose);
        for (0..choose) |i| {
            entry[i] = list[combination[i]];
        }
        try combinations.append(entry);

        // Generate next combination
        var temp: i32 = @intCast(choose - 1);
        while (temp != 0 and combination[@intCast(temp)] == list.len - choose + @as(usize, @intCast(temp))) {
            temp -= 1;
        }
        combination[@intCast(temp)] += 1;
        for ((@as(usize, @intCast(temp)) + 1)..choose) |i| {
            combination[i] = combination[i - 1] + 1;
        }
    }

    return combinations;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var prng = std.Random.DefaultPrng.init(@as(u64, @intCast(std.time.milliTimestamp())));
    var rand = prng.random();

    var pack = try createPackOfCards(allocator);
    defer pack.deinit();

    const cardCounts = [_]usize{ 4, 8, 12 };

    for (cardCounts) |cardCount| {
        // Shuffle pack
        var packSlice = pack.items;
        rand.shuffle(Card, packSlice);

        // Deal cards
        const deal = packSlice[0..cardCount];

        // Print cards dealt
        const stdout = std.io.getStdOut().writer();
        try stdout.print("Cards dealt: {d}\n", .{cardCount});
        for (deal) |card| {
            try stdout.print("[{s} {s} {s} {s}]\n", .{ card[0], card[1], card[2], card[3] });
        }
        try stdout.print("\n", .{});

        // Find and print sets
        try stdout.print("Sets found: \n", .{});
        var combinations = try generateCombinations(allocator, deal, 3);
        defer {
            for (combinations.items) |combo| {
                allocator.free(combo);
            }
            combinations.deinit();
        }

        for (combinations.items) |combo| {
            if (isGameSet(combo)) {
                for (combo) |card| {
                    try stdout.print("[{s} {s} {s} {s}] ", .{ card[0], card[1], card[2], card[3] });
                }
                try stdout.print("\n", .{});
            }
        }
        try stdout.print("-------------------------\n\n", .{});
    }
}
