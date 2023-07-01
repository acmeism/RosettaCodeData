const print = @import("std").debug.print;
pub fn main() void {
    var i: usize = 1;
    while (i <= 100) : (i += 1) {
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
