 const std = @import("std");
 const num = f64;

 pub fn perm(n: num, k: num) num {
     var result: num = 1;
     var i: num = 0;
     while (i < k) : (i += 1) {
         result *= n - i;
     }
     return result;
 }

 pub fn comb(n: num, k: num) num {
     return perm(n, k) / perm(k, k);
 }

 pub fn main() !void {
     var stdout = std.io.getStdOut().writer();

     const p: num = 12;
     const c: num = 60;
     var j: num = 1;
     var k: num = 10;

     while (j < p) : (j += 1) {
         try stdout.print("P({d},{d}) = {d}\n", .{ p, j, @floor(perm(p, j)) });
     }

     while (k < c) : (k += 10) {
         try stdout.print("C({d},{d}) = {d}\n", .{ c, k, @floor(comb(c, k)) });
     }
 }
