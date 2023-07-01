open List
;;
let rec bin n =
  if n < 2 then [n mod 2 = 1]
  else bin (n/2) @ [n mod 2 = 1]
;;
let cut = function
  | [] -> []
  | _ :: x -> x
;;
let multiply a b =
  let ((p, q), (r, s)) = a in
  let ((t, u), (v, w)) = b in
  ((p*t+q*v, p*u+q*w), (r*t+s*v, r*u+s*w))
;;
let fib n =
  let rec f p q r =
    if length r = 1 then
      if nth r 0 then (multiply p q, q)
      else (p, q)
    else
      let (pp, qq) = f p q (cut r) in
      let qqq = multiply qq qq in
      if nth r 0 then (multiply pp qqq, qqq)
      else (pp, qqq) in
  f ((1L, 0L), (0L, 1L)) ((1L, 1L), (1L, 0L)) (bin n) |> fst |> fst |> snd
;;
