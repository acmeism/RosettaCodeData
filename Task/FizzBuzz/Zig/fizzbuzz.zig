const print = @import("std").debug.print;
pub fn main() void {

    for(1..101) |i| {
        if (i % 3 == 0 and i % 5 == 0) {
            print("FizzBuzz\n", .{});
        } else if (i % 3 == 0) {
            print("Fizz\n", .{});
        } else if (i % 5 == 0) {
            print("Buzz\n", .{});
        } else {
            print("{}\n", .{i});
        }
    }
}
