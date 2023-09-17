const assert = @import("std").debug.assert;

pub fn main() void {
    const n: i64 = 43;
    assert(n == 42); // On failure, an `unreachable` is reached
}
