let is_prime n =
  let rec test x =
    x * x > n || n mod x <> 0 && n mod (x + 2) <> 0 && test (x + 6)
  in if n < 5 then n lor 1 = 3 else n land 1 <> 0 && n mod 3 <> 0 && test 5

let seq_squares =
  let rec next n a () = Seq.Cons (n, next (n + a) (a + 2)) in
  next 0 1

let () =
  let cond n = is_prime (succ n) in
  seq_squares |> Seq.take_while ((>) 1000) |> Seq.filter cond
  |> Seq.iter (Printf.printf " %u") |> print_newline
