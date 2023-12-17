const math = @import("std").math;

pub fn binarySearch(comptime T: type, input: []const T, search_value: T) ?usize {
    if (input.len == 0) return null;
    if (@sizeOf(T) == 0) return 0;

    var low: usize = 0;
    var high: usize = input.len - 1;
    return while (low <= high) {
        const mid = ((high - low) / 2) + low;
        const mid_elem: T = input[mid];
        if (mid_elem > search_value)
            high = math.sub(usize, mid, 1) catch break null
        else if (mid_elem < search_value)
            low = mid + 1
        else
            break mid;
    } else null;
}
