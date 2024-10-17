(* speed-optimized exponentiation; doesn't support exponents < 2 *)
let rec pow b n =
  if n land 1 = 0
  then if n = 2 then b * b else pow (b * b) (n lsr 1)
  else if n = 3 then b * b * b else b * pow (b * b) (n lsr 1)

let is_disarium n =
  let rec aux x f =
    if x < 10
    then f 2 x
    else aux (x / 10) (fun l y -> f (succ l) (y + pow (x mod 10) l))
  in
  n = aux n Fun.(const id)

let () =
  Seq.(ints 0 |> filter is_disarium |> take 19 |> iter (Printf.printf " %u%!"))
  |> print_newline
