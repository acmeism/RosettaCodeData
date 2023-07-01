const assert = @import("std").debug.assert;

pub fn main() void {
    assert(1 == 0); // On failure, an `unreachable` is reached
}
