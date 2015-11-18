open Num

let mul (a,b,c) (d,e,f) = let bxe = b*/e in
  (a*/d +/ bxe, a*/e +/ b*/f, bxe +/ c*/f)

let id = (Int 1, Int 0, Int 1)
let rec pow a n =
  if n=0 then id else
    let b = pow a (n/2) in
    if (n mod 2) = 0 then mul b b else mul a (mul b b)

let fib n =
  let (_,y,_) = (pow (Int 1, Int 1, Int 0) n) in
  string_of_num y
;;
Printf.printf "fib %d = %s\n" 300 (fib 300)
