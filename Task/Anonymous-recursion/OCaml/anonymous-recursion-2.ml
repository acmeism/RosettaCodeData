let rec fix f x = f (fix f) x

let fib n =
  if n < 0 then
    None
  else
    Some (fix (fun f -> fun n -> if n <= 1 then 1 else f (n-1) + f (n-2)) n)
