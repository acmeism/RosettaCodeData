let fib n =
  let rec real = function
      0 -> 1
    | 1 -> 1
    | n -> real (n-1) + real (n-2)
  in
  if n < 0 then
    None
  else
    Some (real n)
