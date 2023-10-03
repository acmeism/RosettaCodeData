const std = @import("std");

 pub fn isPrime(n: i64) bool {
     if (@mod(n, 2) == 0) return n == 2;
     if (@mod(n, 3) == 0) return n == 3;
     var d: i64 = 5;
     while (d * d <= n) {
         if (@mod(n, d) == 0) return false;
         d += 2;
         if (@mod(n, d) == 0) return false;
         d += 4;
     }
     return true;
 }
 pub fn main() !void {
     var i: i64 = 42;
     var n: i64 = 0;
     while (n < 42) : (i += 1) {
         if (isPrime(i)) {
             n += 1;
             std.debug.print("n = {d}\t{d}\n", .{ n, i });
             i += i - 1;
         }
     }
 }
