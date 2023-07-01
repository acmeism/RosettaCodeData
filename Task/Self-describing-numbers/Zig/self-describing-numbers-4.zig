/// Return true if number is self describing
fn isSelfDescribing(number: u32) bool {
    // Get the digits (limit scope of variables in a Zig block expression)
    // 1234 -> { 1, 2, 3, 4}
    const digits = blk: {
        var n = number; // Zig parameters are immutable, copy to var.
        // 10 is the maximum number of decimal digits in a 32-bit integer.
        var array: [10]u32 = undefined;

        // Add base 10 digits to array.
        var i: u32 = 0;
        while (n != 0 or i == 0) : (n /= 10) {
            array[i] = n % 10;
            i += 1;
        }
        var slice = array[0..i]; // Slice to give only the digits added.
        std.mem.reverse(u32, slice);
        break :blk slice;
    };
    {
        // wikipedia: last digit must be zero
        if (digits[digits.len - 1] != 0) return false;
    }
    {
        // cannot have a digit >= number of digits
        for (digits) |n| if (n >= digits.len) return false;
    }
    {
        // sum of digits must equal number of digits
        var sum: u32 = 0;
        for (digits) |n| sum += n; // > digits.len short-circuit ?
        if (sum != digits.len) return false;
    }
    {
        // sum of the products of the index and the digit contained at the index
        // should equal the number of digits in the number
        var sum: u32 = 0;
        for (digits, 0..) |n, index| sum += n * @as(u32, @truncate(index));
        if (sum != digits.len) return false;
    }
    // Final elimination. 100% effective. Brute force.
    {
        // Self describing check of digits.
        for (digits, 0..) |expected_count, expected_digit| {
            var count: u8 = 0;
            for (digits) |digit| {
                if (digit == expected_digit) count += 1;
            }
            if (count != expected_count) return false;
        }
    }
    return true;
}
