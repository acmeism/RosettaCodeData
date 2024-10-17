let rec digit_sum n =
  if n < 10 then n else n mod 10 + digit_sum (n / 10)

let is_prime n =
  let rec test x =
    let q = n / x in x > q || x * q <> n && n mod (x + 2) <> 0 && test (x + 6)
  in if n < 5 then n lor 1 = 3 else n land 1 <> 0 && n mod 3 <> 0 && test 5

let is_additive_prime n =
  is_prime n && is_prime (digit_sum n)

let () =
  Seq.ints 0 |> Seq.take_while ((>) 500) |> Seq.filter is_additive_prime
  |> Seq.iter (Printf.printf " %u") |> print_newline
