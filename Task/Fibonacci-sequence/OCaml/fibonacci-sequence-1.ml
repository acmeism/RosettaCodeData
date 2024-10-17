let fib n =
  let rec aux i a b =
    if i = 0 then a else aux (pred i) b (a + b)
  in
  aux n 0 1
