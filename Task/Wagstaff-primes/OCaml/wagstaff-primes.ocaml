let is_prime n =
  let rec test x =
    let q = n / x in x > q || x * q <> n && n mod (x + 2) <> 0 && test (x + 6)
  in if n < 5 then n lor 1 = 3 else n land 1 <> 0 && n mod 3 <> 0 && test 5

let is_wagstaff n =
  let w = succ (1 lsl n) / 3 in
  if is_prime n && is_prime w then Some (n, w) else None

let () =
  let show (p, w) = Printf.printf "%u -> %u%!\n" p w in
  Seq.(ints 3 |> filter_map is_wagstaff |> take 11 |> iter show)
