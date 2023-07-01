const std = @import("std");
fn factorial(n: u64) u64 {
    var total: u64 = 1;
    var i: u64 = 1;
    while (i < n + 1) : (i += 1) {
        total *= i;
    }
    return total;
}
pub fn main() void {
    @setEvalBranchQuota(1000); // minimum loop quota for backwards branches
    const res = comptime factorial(10); // arbitrary Compile Time Function Evaluation
    std.debug.print("res: {d}", .{res}); // output only at runtime
}
