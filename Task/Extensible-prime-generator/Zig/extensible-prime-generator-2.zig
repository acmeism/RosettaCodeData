const std = @import("std");
const sieve = @import("sieve.zig");
const PrimeGen = sieve.PrimeGen;
const heap = std.heap;

const stdout = std.io.getStdOut().writer();
pub fn main() !void {
    try part1();
    try part2();
    try part3();
}

// exercize 1: Print small primes
fn part1() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();

    var primes = PrimeGen(u8).init(&arena.allocator);
    defer primes.deinit();

    try stdout.print("The first 20 primes:", .{});
    while (try primes.next()) |p| {
        try stdout.print(" {}", .{p});
        if (primes.count == 20)
            break;
    }
    try stdout.print("\nThe primes between 100 and 150:", .{});
    while (try primes.next()) |p| if (p >= 100 and p <= 150)
        try stdout.print(" {}", .{p});
    try stdout.print("\n", .{});
}

// exercize 2: count medium primes
fn part2() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();

    var primes = PrimeGen(sieve.autoSieveType(8000)).init(&arena.allocator);
    defer primes.deinit();

    var count: i32 = 0;
    while (try primes.next()) |p| {
        if (p > 8000)
            break;
        if (p > 7700)
            count += 1;
    }
    try stdout.print("There are {} primes between 7700 and 8000.\n", .{count});
}

// exercize 3: find big primes
fn part3() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();

    var primes = PrimeGen(u32).init(&arena.allocator);
    defer primes.deinit();

    var c: u32 = 10;
    while (try primes.next()) |p| {
        if (primes.count == c) {
            try stdout.print("The {}th prime is {}\n", .{ c, p });
            if (c == 100_000_000)
                break;
            c *= 10;
        }
    }
}
