const print = @import("std").debug.print;
fn digitset(numinp: u32, base: u32) u32 {
    var set: u32 = 0;
    var num: u32 = numinp;
    while (num != 0) : (num /= base) {
        set |= @as(u32, 1) << @as(u5, @truncate(num % base));
    }
    return set;
}
pub fn main() void {
    var i: u32 = 0;
    const LIMIT: u32 = 100000;
    while (i < LIMIT) : (i += 1) {
        if (digitset(i, 10) == digitset(i, 16)) {
            print("{}\n", .{i});
        }
    }
}
