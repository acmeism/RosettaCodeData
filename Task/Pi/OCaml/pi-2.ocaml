open Num

(* series for: c*atan(1/k) *)
class atan_sum c k = object
   val kk = k*/k
   val mutable n = 0
   val mutable kpow = k
   val mutable pterm = c*/k
   val mutable psum = Int 0
   val mutable sum = c*/k
   method next =
      n <- n+1; kpow <- kpow*/kk;
      let t = c*/kpow//(Int (2*n+1)) in
      pterm <- if n mod 2 = 0 then t else minus_num t;
      psum <- sum;
      sum <- sum +/ pterm
   method error = abs_num pterm
   method bounds = if pterm </ Int 0 then (sum, psum) else (psum, sum)
end;;

let inv i = (Int 1)//(Int i) in
let t1 = new atan_sum (Int 16) (inv 5) in
let t2 = new atan_sum (Int (-4)) (inv 239) in
let base = Int 10 in
let npr = ref 0 in
let shift = ref (Int 1) in
let d_acc = inv 10000 in
let acc = ref d_acc in
let shown = ref (Int 0) in
while true do
   while t1#error >/ !acc do t1#next done;
   while t2#error >/ !acc do t2#next done;
   let (lo1, hi1), (lo2, hi2) = t1#bounds, t2#bounds in
   let digit x = int_of_num (floor_num ((x -/ !shown) */ !shift)) in
   let d, d' = digit (lo1+/lo2), digit (hi1+/hi2) in
   if d = d' then (
      print_int d;
      if !npr = 0 then print_char '.';
      flush stdout;
      shown := !shown +/ ((Int d) // !shift);
      incr npr; shift := !shift */ base;
   ) else (acc := !acc */ d_acc);
done
