// programme multiplication ethiopienne
// Ethiopian multiplication

const std = @import("std");
const expect = std.testing.expect;
const print = @import("std").debug.print;

pub fn main() !void {
    const Res = multiEth(17,34);
    print("Resultat= {} \n", .{ Res });
}
test "Ethiopian multiplication" {
    try expect(multiEth(20, 10) == 200);
    try expect(multiEth(101, 101) == 10201);
    try expect(multiEth(20, 0) == 0);
    try expect(multiEth(0, 71) == 0);
}


//*****************************
// multiplication
//*****************************
fn multiEth(X: i64, Y: i64) i64 {
    var X1=X;
    var Y1=Y;
    var sum: i64 = 0;
    while (X1>=1) {
       if ((@mod(X1,2)) == 1)
          sum += Y1;
       Y1= Y1 * 2;
       X1 =  @divFloor(X1,2);
    }

    return sum;
}
