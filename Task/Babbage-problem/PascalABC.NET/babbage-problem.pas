//the smallest positive integer whose square ends in the digits 269,696
## var k:=269696;
var n:=trunc(sqrt(k));(* Start with n *)
if n mod 2<>0 then n-=1;(* n:=n-1 *)
  repeat
  n += 2 (* Increase n by 2. n:=n+2 *)
  until (n * n) mod 1000000 = 269696;
$'The smallest positive integer is {n} whose square ends in {k}'.println;
$'{n}² = {n*n}'.println;
