/// Asserts that `array`.len >= 1.
pub fn reduce(comptime T: type, comptime applyFn: fn (T, T) T, array: []const T) T {
    var val: T = array[0];
    for (array[1..]) |elem| {
        val = applyFn(val, elem);
    }
    return val;
}
