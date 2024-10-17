let rec popcount n =
  if n = 0 then 0 else succ (popcount (n land pred n))

let is_prime n =
  let rec test d = d * d > n || n mod d <> 0 && test (d + 2) in
  if n < 3 then n = 2 else n land 1 <> 0 && test 3

let is_pernicious n =
  is_prime (popcount n)

let () =
  Seq.ints 0 |> Seq.filter is_pernicious |> Seq.take 25
  |> Seq.iter (Printf.printf " %u") |> print_newline
and () =
  Seq.ints 888888877 |> Seq.take 12 |> Seq.filter is_pernicious
  |> Seq.iter (Printf.printf " %u") |> print_newline
