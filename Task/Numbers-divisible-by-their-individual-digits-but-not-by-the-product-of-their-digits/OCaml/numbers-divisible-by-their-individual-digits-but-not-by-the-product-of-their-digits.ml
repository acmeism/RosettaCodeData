let test b x =
  let rec loop m n =
    if n < b
    then x mod n = 0 && x mod (m * n) > 0
    else let d = n mod b in d > 0 && x mod d = 0 && loop (m * d) (n / b)
  in loop 1 x

let () =
  Seq.ints 1 |> Seq.take 999 |> Seq.filter (test 10)
  |> Seq.iter (Printf.printf " %u") |> print_newline
