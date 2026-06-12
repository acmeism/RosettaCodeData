const std = @import("std");
const Allocator = std.mem.Allocator;

const SetType = struct {
    items: std.ArrayList([]const u8),
};

fn b2s(allocator: Allocator, i: u32, vars: u32) ![]const u8 {
    var s = try allocator.alloc(u8, vars);
    var idx: u32 = vars;
    var num = i;
    while (idx > 0) {
        idx -= 1;
        s[idx] = if (num & 1 == 1) '1' else '0';
        num >>= 1;
    }
    return s;
}

fn bitCount(s: []const u8) u32 {
    var count: u32 = 0;
    for (s) |c| {
        if (c == '1') count += 1;
    }
    return count;
}

fn merge(allocator: Allocator, i: []const u8, j: []const u8) !?[]const u8 {
    const len = @min(i.len, j.len);
    var difCnt: u32 = 0;
    var s = try allocator.alloc(u8, len);
    for (0..len) |k| {
        const a = i[k];
        const b = j[k];
        if (a == 'X' or b == 'X') {
            if (a != b) {
                allocator.free(s);
                return null;
            }
            s[k] = a;
        } else if (a != b) {
            difCnt += 1;
            if (difCnt > 1) {
                allocator.free(s);
                return null;
            }
            s[k] = 'X';
        } else {
            s[k] = a;
        }
    }
    return s;
}

fn addToSet(set: *SetType, allocator: Allocator, item: []const u8) !void {
    for (set.items.items) |s| {
        if (std.mem.eql(u8, s, item)) {
            return;
        }
    }
    const dup = try allocator.dupe(u8, item);
    try set.items.append(dup);
}

fn inSet(set: *const SetType, item: []const u8) bool {
    for (set.items.items) |s| {
        if (std.mem.eql(u8, s, item)) {
            return true;
        }
    }
    return false;
}

fn unionSets(dest: *SetType, src: *const SetType, allocator: Allocator) !void {
    for (src.items.items) |item| {
        try addToSet(dest, allocator, item);
    }
}

fn computePrimes(allocator: Allocator, cubes: *const SetType, vars: u32, primes: *SetType) !void {
    // Allocate sigma for counts 0..vars
    var sigma = try allocator.alloc(SetType, vars + 1);
    for (sigma) |*set| {
        set.* = SetType{ .items = std.ArrayList([]const u8).init(allocator) };
    }
    var sigmaCount: usize = 0;

    for (0..(vars + 1)) |j| {
        for (cubes.items.items) |cube| {
            if (bitCount(cube) == j) {
                try addToSet(&sigma[j], allocator, cube);
            }
        }
        if (sigma[j].items.items.len > 0) {
            sigmaCount = j + 1;
        }
    }

    primes.items.clearRetainingCapacity();

    while (sigmaCount > 0) {
        const nsigma_len = if (sigmaCount > 1) sigmaCount - 1 else 0;
        var nsigma = try allocator.alloc(SetType, nsigma_len);

        var redundant = SetType{ .items = std.ArrayList([]const u8).init(allocator) };
        defer redundant.items.deinit();

        for (0..(sigmaCount - 1)) |i| {
            nsigma[i] = SetType{ .items = std.ArrayList([]const u8).init(allocator) };
            const c1 = &sigma[i];
            const c2 = &sigma[i + 1];
            for (c1.items.items) |a| {
                for (c2.items.items) |b| {
                    if (try merge(allocator, a, b)) |m| {
                        try addToSet(&nsigma[i], allocator, m);
                        try addToSet(&redundant, allocator, a);
                        try addToSet(&redundant, allocator, b);
                    }
                }
            }
        }

        for (0..sigmaCount) |i| {
            for (sigma[i].items.items) |cube| {
                if (!inSet(&redundant, cube)) {
                    try addToSet(primes, allocator, cube);
                }
            }
        }

        // Free the current sigma
        for (sigma) |*set| {
            set.items.deinit();
        }
        allocator.free(sigma);

        sigma = nsigma;
        sigmaCount = nsigma_len;
    }

    // Free the last sigma (which might be of length 0)
    if (sigma.len > 0) {
        for (sigma) |*set| {
            set.items.deinit();
        }
    }
    allocator.free(sigma);
}

fn activePrimes(allocator: Allocator, cubesel: u32, primes: *const SetType, result: *SetType) !void {
    result.items.clearRetainingCapacity();
    const s = try b2s(allocator, cubesel, @intCast(primes.items.items.len));
    defer allocator.free(s);
    for (primes.items.items, 0..) |prime, i| {
        if (s[i] == '1') {
            try addToSet(result, allocator, prime);
        }
    }
}

fn isCover(prime: []const u8, one: []const u8) bool {
    const len = @min(prime.len, one.len);
    for (0..len) |i| {
        const p = prime[i];
        const o = one[i];
        if (p != 'X' and p != o) {
            return false;
        }
    }
    return true;
}

fn isFullCover(allPrimes: *const SetType, ones: *const SetType) !bool {
    for (ones.items.items) |one| {
        var covered = false;
        for (allPrimes.items.items) |prime| {
            if (isCover(prime, one)) {
                covered = true;
                break;
            }
        }
        if (!covered) {
            return false;
        }
    }
    return true;
}

fn unateCover(allocator: Allocator, primes: *const SetType, ones: *const SetType, result: *SetType) !void {
    var minCount: u32 = 1000;
    var minSel: u32 = 0;
    var found = false;
    var active = SetType{ .items = std.ArrayList([]const u8).init(allocator) };
    defer active.items.deinit();

    const total = @as(u32, 1) << @intCast(primes.items.items.len);
    for (0..total) |cubesel| {
        active.items.clearRetainingCapacity();
        try activePrimes(allocator, @intCast(cubesel), primes, &active);
        if (try isFullCover(&active, ones)) {
            var cnt: u32 = 0;
            const binRep = try b2s(allocator, @intCast(cubesel), @intCast(primes.items.items.len));
            defer allocator.free(binRep);
            for (binRep) |c| {
                if (c == '1') cnt += 1;
            }
            if (cnt < minCount) {
                minCount = cnt;
                minSel = @intCast(cubesel);
                found = true;
            }
        }
    }

    if (found) {
        result.items.clearRetainingCapacity();
        try activePrimes(allocator, minSel, primes, result);
    } else {
        result.items.clearRetainingCapacity();
    }
}

fn qm(allocator: Allocator, ones: []const u32, zeros: []const u32, dc: []const u32, result: *SetType) !void {
    if (ones.len == 0 and zeros.len == 0 and dc.len == 0) {
        return;
    }

    var maxVal: u32 = 0;
    for (ones) |val| {
        if (val > maxVal) maxVal = val;
    }
    for (zeros) |val| {
        if (val > maxVal) maxVal = val;
    }
    for (dc) |val| {
        if (val > maxVal) maxVal = val;
    }

    var numvars: u32 = 0;
    if (maxVal == 0) {
        numvars = 1;
    } else {
        var tmp = maxVal;
        while (tmp != 0) {
            numvars += 1;
            tmp >>= 1;
        }
    }

    var onesSet = SetType{ .items = std.ArrayList([]const u8).init(allocator) };
    defer onesSet.items.deinit();
    var zerosSet = SetType{ .items = std.ArrayList([]const u8).init(allocator) };
    defer zerosSet.items.deinit();
    var dcSet = SetType{ .items = std.ArrayList([]const u8).init(allocator) };
    defer dcSet.items.deinit();

    for (ones) |val| {
        const s = try b2s(allocator, val, numvars);
        defer allocator.free(s);
        try addToSet(&onesSet, allocator, s);
    }
    for (zeros) |val| {
        const s = try b2s(allocator, val, numvars);
        defer allocator.free(s);
        try addToSet(&zerosSet, allocator, s);
    }
    for (dc) |val| {
        const s = try b2s(allocator, val, numvars);
        defer allocator.free(s);
        try addToSet(&dcSet, allocator, s);
    }

    var cubes = SetType{ .items = std.ArrayList([]const u8).init(allocator) };
    defer cubes.items.deinit();
    try unionSets(&cubes, &onesSet, allocator);
    try unionSets(&cubes, &dcSet, allocator);

    var primes = SetType{ .items = std.ArrayList([]const u8).init(allocator) };
    defer primes.items.deinit();
    try computePrimes(allocator, &cubes, numvars, &primes);

    try unateCover(allocator, &primes, &onesSet, result);
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const ones = [_]u32{ 1, 2, 5 };
    const zeros = [_]u32{};
    const dc = [_]u32{ 0, 7 };

    var result = SetType{ .items = std.ArrayList([]const u8).init(allocator) };
    try qm(allocator, &ones, &zeros, &dc, &result);

    for (result.items.items) |item| {
        std.debug.print("{s} ", .{item});
    }
    std.debug.print("\n", .{});
}
