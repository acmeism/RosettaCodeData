const std = @import("std");
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;
const Allocator = std.mem.Allocator;

// Custom hash function for byte slices
fn hashBytes(bytes: []const u8) u64 {
    var hash: u64 = 0;
    for (bytes) |byte| {
        hash = hash *% 31 +% byte;
    }
    return hash;
}

// Context for HashMap with byte slice keys
const ByteSliceContext = struct {
    pub fn hash(self: @This(), key: []const u8) u64 {
        _ = self;
        return hashBytes(key);
    }

    pub fn eql(self: @This(), a: []const u8, b: []const u8) bool {
        _ = self;
        return std.mem.eql(u8, a, b);
    }
};

const DictMap = HashMap([]const u8, u32, ByteSliceContext, std.hash_map.default_max_load_percentage);
const ReverseDictMap = HashMap(u32, []const u8, std.hash_map.AutoContext(u32), std.hash_map.default_max_load_percentage);

fn compress(allocator: Allocator, data: []const u8) !ArrayList(u32) {
    // Build initial dictionary
    var dictionary = DictMap.init(allocator);
    defer {
        // Clean up allocated dictionary keys
        var iterator = dictionary.iterator();
        while (iterator.next()) |entry| {
            allocator.free(entry.key_ptr.*);
        }
        dictionary.deinit();
    }

    // Initialize dictionary with single bytes (0-255)
    for (0..256) |i| {
        const key = try allocator.alloc(u8, 1);
        key[0] = @intCast(i);
        try dictionary.put(key, @intCast(i));
    }

    var w = ArrayList(u8){};
    defer w.deinit(allocator);

    var compressed = ArrayList(u32){};

    for (data) |b| {
        // Create wc = w + b
        var wc = try w.clone(allocator);
        defer wc.deinit(allocator);
        try wc.append(allocator, b);

        if (dictionary.contains(wc.items)) {
            // Update w to wc
            w.deinit(allocator);
            w = try wc.clone(allocator);
        } else {
            // Write w to output
            if (w.items.len > 0) {
                const code = dictionary.get(w.items).?;
                try compressed.append(allocator, code);
            }

            // wc is a new sequence; add it to the dictionary
            const new_key = try allocator.dupe(u8, wc.items);
            try dictionary.put(new_key, @intCast(dictionary.count()));

            // Reset w to single byte b
            w.deinit(allocator);
            w = ArrayList(u8){};
            try w.append(allocator, b);
        }
    }

    // Write remaining output if necessary
    if (w.items.len > 0) {
        const code = dictionary.get(w.items).?;
        try compressed.append(allocator, code);
    }

    return compressed;
}

fn decompress(allocator: Allocator, data: []const u32) !ArrayList(u8) {
    if (data.len == 0) {
        return ArrayList(u8){};
    }

    // Build the dictionary
    var dictionary = ReverseDictMap.init(allocator);
    defer {
        // Clean up allocated dictionary values
        var iterator = dictionary.iterator();
        while (iterator.next()) |entry| {
            allocator.free(entry.value_ptr.*);
        }
        dictionary.deinit();
    }

    // Initialize dictionary with single bytes (0-255)
    for (0..256) |i| {
        const value = try allocator.alloc(u8, 1);
        value[0] = @intCast(i);
        try dictionary.put(@intCast(i), value);
    }

    // Get first sequence
    const first_entry = dictionary.get(data[0]).?;
    var w = try allocator.dupe(u8, first_entry);
    defer allocator.free(w);

    var decompressed = ArrayList(u8){};
    try decompressed.appendSlice(allocator, w);

    for (data[1..]) |k| {
        var entry: []const u8 = undefined;
        var should_free_entry = false;

        if (dictionary.contains(k)) {
            entry = dictionary.get(k).?;
        } else if (k == dictionary.count()) {
            // Special case: k is not in dictionary yet
            var temp_entry = try allocator.alloc(u8, w.len + 1);
            @memcpy(temp_entry[0..w.len], w);
            temp_entry[w.len] = w[0];
            entry = temp_entry;
            should_free_entry = true;
        } else {
            std.debug.panic("Invalid dictionary key: {}\n", .{k});
        }

        try decompressed.appendSlice(allocator, entry);

        // New sequence; add it to the dictionary
        var new_sequence = try allocator.alloc(u8, w.len + 1);
        @memcpy(new_sequence[0..w.len], w);
        new_sequence[w.len] = entry[0];
        try dictionary.put(@intCast(dictionary.count()), new_sequence);

        // Update w
        allocator.free(w);
        w = try allocator.dupe(u8, entry);

        if (should_free_entry) {
            allocator.free(entry);
        }
    }

    return decompressed;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input = "TOBEORNOTTOBEORTOBEORNOT";

    var compressed = try compress(allocator, input);
    defer compressed.deinit(allocator);

    std.debug.print("Compressed: " , .{} );
    for (compressed.items) |code| {
        std.debug.print("{} ", .{code});
    }
    std.debug.print("\n" , .{});

    var decompressed = try decompress(allocator, compressed.items);
    defer decompressed.deinit(allocator);

    std.debug.print("Decompressed bytes: " , .{});
    for (decompressed.items) |byte| {
        std.debug.print("{} ", .{byte});
    }
    std.debug.print("\n" , .{});

    std.debug.print("Decompressed: {s}\n", .{decompressed.items});
}
