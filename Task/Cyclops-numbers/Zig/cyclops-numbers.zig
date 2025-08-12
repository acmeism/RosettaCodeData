const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const first50 = try firstCyclops(allocator, 50);
    defer first50.deinit();
    print("First 50 cyclops numbers:\n" , .{});
    printVector(first50.items, 10);

    const prime50 = try firstCyclopsPrimes(allocator, 50);
    defer prime50.deinit();
    print("\nFirst 50 prime cyclops numbers:\n" , .{});
    printVector(prime50.items, 10);

    const blind50 = try firstBlindCyclopsPrimes(allocator, 50);
    defer blind50.deinit();
    print("\nFirst 50 blind prime cyclops numbers:\n" , .{});
    printVector(blind50.items, 10);

    const palindrome50 = try firstPalindromeCyclopsPrimes(allocator, 50);
    defer palindrome50.deinit();
    print("\nFirst 50 palindromic prime cyclops numbers:\n" , .{});
    printVector(palindrome50.items, 10);
}

fn printVector(v: []const i32, nc: usize) void {
    var col: usize = 0;
    for (v) |e| {
        print("{:8}   ", .{e});
        col += 1;
        if (col == nc) {
            print("\n" , .{});
            col = 0;
        }
    }
}

fn isCyclopsNumber(n: i32) bool {
    if (n == 0) {
        return true;
    }

    var num = n;
    var m = @rem(num, 10);
    var count: i32 = 0;

    // Count digits before the zero
    while (m != 0) {
        count += 1;
        num = @divTrunc(num, 10);
        m = @rem(num, 10);
    }

    // Skip the zero
    num = @divTrunc(num, 10);
    m = @rem(num, 10);

    // Count digits after the zero
    while (m != 0) {
        count -= 1;
        num = @divTrunc(num, 10);
        m = @rem(num, 10);
    }

    return num == 0 and count == 0;
}

fn firstCyclops(allocator: Allocator, n: usize) !ArrayList(i32) {
    var result = ArrayList(i32).init(allocator);
    var i: i32 = 0;

    while (result.items.len < n) {
        if (isCyclopsNumber(i)) {
            try result.append(i);
        }
        i += 1;
    }

    return result;
}

fn isPrime(n: i32) bool {
    if (n < 2) {
        return false;
    }

    const sqrt_n = @as(i32, @intFromFloat(@sqrt(@as(f64, @floatFromInt(n)))));
    var i: i32 = 2;
    while (i <= sqrt_n) : (i += 1) {
        if (@rem(n, i) == 0) {
            return false;
        }
    }

    return true;
}

fn firstCyclopsPrimes(allocator: Allocator, n: usize) !ArrayList(i32) {
    var result = ArrayList(i32).init(allocator);
    var i: i32 = 0;

    while (result.items.len < n) {
        if (isCyclopsNumber(i) and isPrime(i)) {
            try result.append(i);
        }
        i += 1;
    }

    return result;
}

fn blindCyclops(n: i32) i32 {
    var num = n;
    var m = @rem(num, 10);
    var k: i32 = 0;

    // Extract digits before the zero
    while (m != 0) {
        k = 10 * k + m;
        num = @divTrunc(num, 10);
        m = @rem(num, 10);
    }

    // Skip the zero
    num = @divTrunc(num, 10);

    // Reconstruct the number by reversing the first part
    while (k != 0) {
        m = @rem(k, 10);
        num = 10 * num + m;
        k = @divTrunc(k, 10);
    }

    return num;
}

fn firstBlindCyclopsPrimes(allocator: Allocator, n: usize) !ArrayList(i32) {
    var result = ArrayList(i32).init(allocator);
    var i: i32 = 0;

    while (result.items.len < n) {
        if (isCyclopsNumber(i) and isPrime(i)) {
            const j = blindCyclops(i);
            if (isPrime(j)) {
                try result.append(i);
            }
        }
        i += 1;
    }

    return result;
}

fn isPalindrome(n: i32) bool {
    var k: i32 = 0;
    var l = n;

    while (l != 0) {
        const m = @rem(l, 10);
        k = 10 * k + m;
        l = @divTrunc(l, 10);
    }

    return n == k;
}

fn firstPalindromeCyclopsPrimes(allocator: Allocator, n: usize) !ArrayList(i32) {
    var result = ArrayList(i32).init(allocator);
    var i: i32 = 0;

    while (result.items.len < n) {
        if (isCyclopsNumber(i) and isPrime(i) and isPalindrome(i)) {
            try result.append(i);
        }
        i += 1;
    }

    return result;
}
