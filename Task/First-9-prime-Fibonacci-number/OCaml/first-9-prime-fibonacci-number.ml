let is_prime n =
  let rec test x =
    x * x > n || n mod x <> 0 && n mod (x + 2) <> 0 && test (x + 6)
  in
  if n < 5
  then n land 2 <> 0
  else n land 1 <> 0 && n mod 3 <> 0 && test 5

let seq_fibonacci =
  let rec next b a () = Seq.Cons (a, next (b + a) b) in
  next 1 0

let () =
  seq_fibonacci |> Seq.filter is_prime |> Seq.take 9
  |> Seq.iter (Printf.printf " %u") |> print_newline
