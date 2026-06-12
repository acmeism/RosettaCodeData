let seq_odd_squares =
  let rec next n a () = Seq.Cons (n, next (n + a) (a + 8)) in
  next 1 8

let () =
  seq_odd_squares |> Seq.drop_while ((>) 100) |> Seq.take_while ((>) 1000)
  |> Seq.iter (Printf.printf " %u") |> print_newline
