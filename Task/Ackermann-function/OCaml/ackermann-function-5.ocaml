open Big_int
let one  = unit_big_int
let zero = zero_big_int
let succ = succ_big_int
let pred = pred_big_int
let eq = eq_big_int

let rec a m n =
  if eq m zero then (succ n) else
  if eq n zero then (a (pred m) one) else
  (a (pred m) (a m (pred n)))
