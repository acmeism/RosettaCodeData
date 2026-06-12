pub fn sumsUpTo(comptime T: type, input: []const T, target_sum: T) ?struct { usize, usize } {
    if (input.len <= 1) return null;

    return result: for (input[0 .. input.len - 1], 0..) |left, left_i| {
        if (left > target_sum) break :result null;

        const offset = left_i + 1;
        for (input[offset..], offset..) |right, right_i| {
            const current_sum = left + right;
            if (current_sum < target_sum) continue;
            if (current_sum == target_sum) break :result .{ left_i, right_i };
            if (current_sum > target_sum) break;
        }
    } else null;
}
