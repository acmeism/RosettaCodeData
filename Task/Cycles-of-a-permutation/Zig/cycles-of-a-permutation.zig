const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;

// --- Type Aliases ---
const OneLine = ArrayList(u32);
const Cycles = ArrayList(OneLine);

// --- Permutation Struct ---
const Permutation = struct {
    letters_count: u32,
    allocator: std.mem.Allocator,

    const Self = @This();

    // Initialize the length of the strings to be permuted
    pub fn init(allocator: std.mem.Allocator, letters_size: u32) Self {
        return Permutation{
            .letters_count = letters_size,
            .allocator = allocator,
        };
    }

    // Return the permutation in one line form that transforms the string 'source' into the string 'destination'
    pub fn createOneLine(self: *const Self, source: []const u8, destination: []const u8) !OneLine {
        var result = OneLine.init(self.allocator);

        for (destination) |ch| {
            if (std.mem.indexOf(u8, source, &[_]u8{ch})) |pos| {
                try result.append(@intCast(pos + 1));
            } else {
                // Handle case where character is not found
                std.debug.panic("Character '{}' not found in source string '{s}'", .{ ch, source });
            }
        }

        // Remove trailing fixed points (elements where value equals its 1-based index)
        while (result.items.len > 0 and result.items[result.items.len - 1] == result.items.len) {
            _ = result.pop();
        }

        return result;
    }

    // Return the cycles of the permutation given in one line form
    pub fn oneLineToCycles(self: *const Self, one_line: *const OneLine) !Cycles {
        var cycles = Cycles.init(self.allocator);
        var used = std.AutoHashMap(u32, void).init(self.allocator);
        defer used.deinit();

        // Iterate only through elements present in one_line
        for (one_line.items) |number| {
            // Process the number only if it hasn't been included in a cycle yet
            if (!used.contains(number)) {
                // Find the 1-based index of 'number' in the one_line vector
                if (std.mem.indexOf(u32, one_line.items, &[_]u32{number})) |pos| {
                    var index: u32 = @intCast(pos + 1);
                    var cycle = OneLine.init(self.allocator);
                    try cycle.append(number);

                    // Continue building the cycle until it closes
                    while (number != index) {
                        try cycle.append(index);
                        // Find the next index based on the current value
                        if (std.mem.indexOf(u32, one_line.items, &[_]u32{index})) |next_pos| {
                            index = @intCast(next_pos + 1);
                        } else {
                            index = number; // Default fallback
                        }
                    }

                    // Only add cycles of length greater than 1
                    if (cycle.items.len > 1) {
                        try cycles.append(cycle);
                        // Mark all elements in the cycle as used
                        for (cycle.items) |item| {
                            try used.put(item, {});
                        }
                    } else {
                        cycle.deinit();
                    }
                }
            }
        }
        return cycles;
    }

    // Return the one line notation of the permutation given in cycle form
    pub fn cyclesToOneLine(self: *const Self, cycles: *const Cycles) !OneLine {
        // Initialize with identity permutation (1, 2, ..., n)
        var one_line = OneLine.init(self.allocator);
        var i: u32 = 1;
        while (i <= self.letters_count) : (i += 1) {
            try one_line.append(i);
        }

        var number: u32 = 1;
        while (number <= self.letters_count) : (number += 1) {
            for (cycles.items) |cycle| {
                // Find the index of 'number' within the current cycle
                if (std.mem.indexOf(u32, cycle.items, &[_]u32{number})) |index| {
                    // Map 'number' to the preceding element in the cycle (wrapping around)
                    const prev_index = if (index > 0) index - 1 else cycle.items.len - 1;
                    // Adjust for 0-based indexing
                    one_line.items[number - 1] = cycle.items[prev_index];
                    break; // Move to the next number once the cycle is found
                }
            }
        }
        return one_line;
    }

    // Return the inverse of the given permutation in cycle form
    pub fn cyclesInverse(self: *const Self, cycles: *const Cycles) !Cycles {
        var cycles_inverse = Cycles.init(self.allocator);

        for (cycles.items) |cycle| {
            var new_cycle = OneLine.init(self.allocator);

            // Clone the cycle
            for (cycle.items) |item| {
                try new_cycle.append(item);
            }

            // Rotate the cycle: move the first element to the end
            if (new_cycle.items.len > 0) {
                const first_element = new_cycle.orderedRemove(0);
                try new_cycle.append(first_element);
            }

            // Reverse the order of elements in the cycle
            std.mem.reverse(u32, new_cycle.items);

            try cycles_inverse.append(new_cycle);
        }
        return cycles_inverse;
    }

    // Return the inverse of the given permutation in one line notation
    pub fn oneLineInverse(self: *const Self, one_line: *const OneLine) !OneLine {
        // Initialize with zeros, matching the length of the input one_line
        var one_line_inverse = OneLine.init(self.allocator);
        try one_line_inverse.resize(one_line.items.len);
        @memset(one_line_inverse.items, 0);

        for (one_line.items, 0..) |value, index_zero_based| {
            const one_based_index: u32 = @intCast(index_zero_based + 1);
            // Place the 1-based index at the position indicated by the value (adjusted for 0-based indexing)
            // Bounds check to prevent potential panics
            if (value > 0 and value <= one_line.items.len) {
                one_line_inverse.items[value - 1] = one_based_index;
            }
        }
        return one_line_inverse;
    }

    // Return the element to which the given number is mapped by the permutation given in cycle form
    pub fn nextInCycles(self: *const Self, cycles: *const Cycles, number: u32) u32 {
        _ = self; // unused parameter
        for (cycles.items) |cycle| {
            // Check if the number exists in the current cycle
            if (std.mem.indexOf(u32, cycle.items, &[_]u32{number})) |index| {
                // Return the next element in the cycle (wrapping around using modulo)
                return cycle.items[(index + 1) % cycle.items.len];
            }
        }
        // If the number is not found in any cycle, it's a fixed point, so it maps to itself
        return number;
    }

    // Return the cycles obtained by composing cycle_one first followed by cycle_two
    pub fn combinedCycles(self: *const Self, cycles_one: *const Cycles, cycles_two: *const Cycles) !Cycles {
        var combined_cycles = Cycles.init(self.allocator);
        var used = std.AutoHashMap(u32, void).init(self.allocator);
        defer used.deinit();

        // Iterate through all possible numbers up to the total letter count
        var number: u32 = 1;
        while (number <= self.letters_count) : (number += 1) {
            // Process the number only if it hasn't been included in a cycle yet
            if (!used.contains(number)) {
                // Calculate the result of applying cycles_one followed by cycles_two
                const combined = self.nextInCycles(cycles_two, self.nextInCycles(cycles_one, number));

                var cycle = OneLine.init(self.allocator);
                try cycle.append(number); // Start building the new cycle

                // Continue building the cycle until it closes
                var current = combined;
                while (number != current) {
                    try cycle.append(current);
                    // Apply the combined transformation again
                    current = self.nextInCycles(cycles_two, self.nextInCycles(cycles_one, current));
                }

                // Add the cycle if it has more than one element
                if (cycle.items.len > 1) {
                    try combined_cycles.append(cycle);
                    // Mark all elements in the cycle as used
                    for (cycle.items) |item| {
                        try used.put(item, {});
                    }
                } else {
                    cycle.deinit();
                }
            }
        }
        return combined_cycles;
    }

    // Return the given string permuted by the permutation given in one line form
    pub fn oneLinePermuteString(self: *const Self, text: []const u8, one_line: *const OneLine) ![]u8 {
        var permuted_chars = ArrayList(u8).init(self.allocator);

        // Iterate through the indices specified in the one_line notation
        for (one_line.items) |index| {
            const zero_based_index = index - 1;
            // Get the character from the original text at the specified index
            if (zero_based_index < text.len) {
                try permuted_chars.append(text[zero_based_index]);
            }
        }

        // Append the remaining characters from the original text that were not specified by the one_line
        // (These correspond to fixed points at the end)
        const permuted_len = permuted_chars.items.len;
        if (permuted_len < text.len) {
            for (text[permuted_len..]) |ch| {
                try permuted_chars.append(ch);
            }
        }

        return permuted_chars.toOwnedSlice();
    }

    // Return the given string permuted by the permutation given in cycle form
    pub fn cyclesPermuteString(self: *const Self, text: []const u8, cycles: *const Cycles) ![]u8 {
        // Start with the original text as a vector of characters for mutability
        var permuted_chars = ArrayList(u8).init(self.allocator);
        for (text) |ch| {
            try permuted_chars.append(ch);
        }

        // Apply each cycle to the character vector
        for (cycles.items) |cycle| {
            // For each element in the cycle, move the character from its current position
            // to the position of the next element in the cycle
            for (cycle.items) |number| {
                const target_index = self.nextInCycles(cycles, number) - 1; // 0-based target index
                const source_index = number - 1; // 0-based source index
                // Ensure indices are within bounds before accessing
                if (source_index < text.len and target_index < text.len) {
                    // Get the character from the original text at source_index
                    permuted_chars.items[target_index] = text[source_index];
                }
            }
        }

        return permuted_chars.toOwnedSlice();
    }

    // Return the signature of the permutation given in one line form
    pub fn signature(self: *const Self, one_line: *const OneLine) ![]const u8 {
        const cycles = try self.oneLineToCycles(one_line);
        defer {
            for (cycles.items) |cycle| {
                cycle.deinit();
            }
            cycles.deinit();
        }

        var even_count: u32 = 0;

        // Count the number of cycles of even length
        for (cycles.items) |cycle| {
            if (cycle.items.len % 2 == 0) {
                even_count += 1;
            }
        }

        // The signature is -1 if the number of even-length cycles is odd, otherwise +1
        if (even_count % 2 == 0) {
            return "+1";
        } else {
            return "-1";
        }
    }

    // Return the order of the permutation given in one line form
    pub fn order(self: *const Self, one_line: *const OneLine) !u32 {
        const cycles = try self.oneLineToCycles(one_line);
        defer {
            for (cycles.items) |cycle| {
                cycle.deinit();
            }
            cycles.deinit();
        }

        var lcm_result: u32 = 1;

        // Calculate the LCM of the lengths of all cycles
        for (cycles.items) |cycle| {
            const cycle_size: u32 = @intCast(cycle.items.len);
            // Update LCM using the formula: LCM(a, b) = a * b / GCD(a, b)
            if (cycle_size > 0) {
                lcm_result = lcm_result * cycle_size / gcd(lcm_result, cycle_size);
            }
        }

        return lcm_result;
    }

    pub fn deinit(self: *Self) void {
        _ = self; // Currently no cleanup needed
    }
};

// Helper function to calculate the Greatest Common Divisor (GCD)
fn gcd(a: u32, b: u32) u32 {
    if (b == 0) {
        return a;
    } else {
        return gcd(b, a % b);
    }
}

// --- Display Functions ---
fn cyclesToString(allocator: std.mem.Allocator, cycles: *const Cycles) ![]u8 {
    var result = ArrayList(u8).init(allocator);
    for (cycles.items) |cycle| {
        const cycle_str = try oneLineToString(allocator, &cycle);
        defer allocator.free(cycle_str);
        try result.appendSlice(cycle_str);
    }
    return result.toOwnedSlice();
}

fn oneLineToString(allocator: std.mem.Allocator, one_line: *const OneLine) ![]u8 {
    if (one_line.items.len == 0) {
        return try allocator.dupe(u8, "()");
    }

    var result = ArrayList(u8).init(allocator);
    try result.append('(');

    for (one_line.items, 0..) |number, i| {
        if (i > 0) {
            try result.append(' ');
        }
        const num_str = try std.fmt.allocPrint(allocator, "{}", .{number});
        defer allocator.free(num_str);
        try result.appendSlice(num_str);
    }

    try result.appendSlice(") ");
    return result.toOwnedSlice();
}

// --- Main Function ---
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Define day names and corresponding letter arrangements
    const DAY_NAMES = [_][]const u8{ "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY" };
    const LETTERS = [_][]const u8{
        "HANDYCOILSERUPT",
        "SPOILUNDERYACHT",
        "DRAINSTYLEPOUCH",
        "DITCHSYRUPALONE",
        "SOAPYTHIRDUNCLE",
        "SHINEPARTYCLOUD",
        "RADIOLUNCHTYPES",
    };

    // Helper function to get the previous day's index
    const previousDay = struct {
        fn f(today: usize) usize {
            return (7 + today - 1) % 7;
        }
    }.f;

    // Create a Permutation instance based on the length of the letter strings
    var permutation = Permutation.init(allocator, @intCast(LETTERS[0].len));
    defer permutation.deinit();

    // --- Output Section ---

    print("On Thursdays Alf and Betty should rearrange their letters using these cycles:\n" , .{});
    var one_line_wed_thu = try permutation.createOneLine(LETTERS[2], LETTERS[3]); // WEDNESDAY to THURSDAY
    defer one_line_wed_thu.deinit();

    var cycles_wed_thu = try permutation.oneLineToCycles(&one_line_wed_thu);
    defer {
        for (cycles_wed_thu.items) |cycle| {
            cycle.deinit();
        }
        cycles_wed_thu.deinit();
    }

    const cycles_str = try cyclesToString(allocator, &cycles_wed_thu);
    defer allocator.free(cycles_str);
    print("{s}\n", .{cycles_str});
    print("So that {s} becomes {s}\n", .{ LETTERS[2], LETTERS[3] });

    print("\nOr they could use the one line notation:\n" , .{});
    const one_line_str = try oneLineToString(allocator, &one_line_wed_thu);
    defer allocator.free(one_line_str);
    print("{s}\n", .{one_line_str});

    print("\nTo revert to the Wednesday arrangement they should use these cycles:\n" , .{});
    var cycles_thu_wed = try permutation.cyclesInverse(&cycles_wed_thu);
    defer {
        for (cycles_thu_wed.items) |cycle| {
            cycle.deinit();
        }
        cycles_thu_wed.deinit();
    }

    const cycles_inv_str = try cyclesToString(allocator, &cycles_thu_wed);
    defer allocator.free(cycles_inv_str);
    print("{s}\n", .{cycles_inv_str});

    print("\nOr with the one line notation:\n" , .{});
    var one_line_thu_wed = try permutation.oneLineInverse(&one_line_wed_thu);
    defer one_line_thu_wed.deinit();

    const one_line_inv_str = try oneLineToString(allocator, &one_line_thu_wed);
    defer allocator.free(one_line_inv_str);
    print("{s}\n", .{one_line_inv_str});

    const permuted_result = try permutation.oneLinePermuteString(LETTERS[3], &one_line_thu_wed);
    defer allocator.free(permuted_result);
    print("So that {s} becomes {s}\n", .{ LETTERS[3], permuted_result });

    print("\nStarting with the Sunday arrangement and applying each of the daily\n"  , .{});
    print("arrangements consecutively, the arrangements will be:\n\n" , .{});
    print("{s:>11} {s}\n", .{ "", LETTERS[6] }); // SUNDAY

    for (DAY_NAMES, 0..) |day_name, today_index| {
        const prev_index = previousDay(today_index);
        var day_one_line = try permutation.createOneLine(LETTERS[prev_index], LETTERS[today_index]);
        defer day_one_line.deinit();

        const permuted_string = try permutation.oneLinePermuteString(LETTERS[prev_index], &day_one_line);
        defer allocator.free(permuted_string);
        print("{s:>11}: {s}\n", .{ day_name, permuted_string });

        if (std.mem.eql(u8, day_name, "SATURDAY")) {
            print("\n" , .{}); // Extra newline after Saturday
        }
    }

    print("To go from Wednesday to Friday in a single step they should use these cycles:\n"  , .{});
    var one_line_thu_fri = try permutation.createOneLine(LETTERS[3], LETTERS[4]); // THURSDAY to FRIDAY
    defer one_line_thu_fri.deinit();

    var cycles_thu_fri = try permutation.oneLineToCycles(&one_line_thu_fri);
    defer {
        for (cycles_thu_fri.items) |cycle| {
            cycle.deinit();
        }
        cycles_thu_fri.deinit();
    }

    var cycles_wed_fri = try permutation.combinedCycles(&cycles_wed_thu, &cycles_thu_fri);
    defer {
        for (cycles_wed_fri.items) |cycle| {
            cycle.deinit();
        }
        cycles_wed_fri.deinit();
    }

    const cycles_combined_str = try cyclesToString(allocator, &cycles_wed_fri);
    defer allocator.free(cycles_combined_str);
    print("{s}\n", .{cycles_combined_str});

    const permuted_wed_fri = try permutation.cyclesPermuteString(LETTERS[2], &cycles_wed_fri);
    defer allocator.free(permuted_wed_fri);
    print("So that {s} becomes {s}\n", .{ LETTERS[2], permuted_wed_fri });

    print("\nThese are the signatures of the permutations:\n\n" , .{});
    for (DAY_NAMES, 0..) |day_name, today_index| {
        const prev_index = previousDay(today_index);
        var one_line = try permutation.createOneLine(LETTERS[prev_index], LETTERS[today_index]);
        defer one_line.deinit();

        const sig = try permutation.signature(&one_line);
        print("{s:>11}: {s}\n", .{ day_name, sig });
    }

    print("\nThese are the orders of the permutations:\n\n" , .{});
    for (DAY_NAMES, 0..) |day_name, today_index| {
        const prev_index = previousDay(today_index);
        var one_line = try permutation.createOneLine(LETTERS[prev_index], LETTERS[today_index]);
        defer one_line.deinit();

        const ord = try permutation.order(&one_line);
        print("{s:>11}: {}\n", .{ day_name, ord });
    }

    print("\nApplying the Friday cycle to a string 10 times:\n" , .{});
    var previous = try allocator.dupe(u8, "STOREDAILYPUNCH");
    defer allocator.free(previous);
    print("\n{:>2} {s}\n", .{ 0, previous });

    var i: u32 = 1;
    while (i <= 10) : (i += 1) {
        const new_previous = try permutation.cyclesPermuteString(previous, &cycles_thu_fri);
        allocator.free(previous);
        previous = new_previous;
        print("{:>2} {s}\n", .{ i, previous });
        if (i == 9) {
            print("\n"   , .{}); // Extra newline after iteration 9
        }
    }
}
