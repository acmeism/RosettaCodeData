let is_prime n =
  let rec test x =
    x * x > n || n mod x <> 0 && n mod (x + 2) <> 0 && test (x + 6)
  in
  if n < 5
  then n lor 1 = 3
  else n land 1 <> 0 && n mod 3 <> 0 && test 5
