// Return true if number is self describing
fn isSelfDescribing(number: u32) bool {
    var n = number; // Zig parameters are immutable, copy to var.

    // 10 is the maximum number of decimal digits in a 32-bit integer.
    var array: [10]u32 = undefined;

    // Add digits to array.
    var i: u32 = 0;
    while (n != 0 or i == 0) : (n /= 10) {
        array[i] = n % 10;
        i += 1;
    }
    var digits = array[0..i]; // Slice to give just the digits added.
    std.mem.reverse(u32, digits);

    // Check digits. Brute force.
    for (digits, 0..) |predicted_count, predicted_digit| {
        var count: u8 = 0;
        for (digits) |digit| {
            if (digit == predicted_digit) count += 1;
        }
        if (count != predicted_count) return false;
    }
    return true;
}
