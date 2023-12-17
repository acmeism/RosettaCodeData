const math = @import("std").math;

pub fn binarySearch(comptime T: type, input: []const T, search_value: T) ?usize {
    if (input.len == 0) return null;
    if (@sizeOf(T) == 0) return 0;

    return binarySearchInner(T, input, search_value, 0, input.len - 1);
}

fn binarySearchInner(comptime T: type, input: []const T, search_value: T, low: usize, high: usize) ?usize {
    if (low > high) return null;

    const mid = ((high - low) / 2) + low;
    const mid_elem: T = input[mid];

    return if (mid_elem > search_value)
        binarySearchInner(T, input, search_value, low, math.sub(usize, mid, 1) catch return null)
    else if (mid_elem < search_value)
        binarySearchInner(T, input, search_value, mid + 1, high)
    else
        mid;
}
