#load "nums.cma";;
open Num;;

let binomial n p =
   let m = min p (n - p) in
   if m < 0 then Int 0 else
   let rec a j v =
      if j = m then v
      else a (succ j) ((v */ (Int (n - j))) // (Int (succ j)))
   in a 0 (Int 1)
;;
