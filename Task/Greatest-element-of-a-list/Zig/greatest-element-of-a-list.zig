/// Asserts that `input` is not empty (len >= 1).
pub fn max(comptime T: type, input: []const T) T {
    var max_elem: T = input[0];
    for (input[1..]) |elem| {
        max_elem = @max(max_elem, elem);
    }
    return max_elem;
}
