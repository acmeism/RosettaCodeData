const std = @import("std");
const print = @import("std").debug.print;


pub fn main() !void {
    var number: u64 = 2;
    while(true) {
    const sq= number * number;
    const number1= number - 1;
    const sq1= number1 * number1;
    if (sq - sq1 > 1000 ) {
       print("Result= {}\n", .{ number });
       break;
       }
    number += 1;
    if (number > 10000) {
       print("No find ! \n",.{});
       break;
       }
    }
}
