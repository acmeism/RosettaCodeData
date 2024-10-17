let seq_leonardo i =
  let rec next b a () = Seq.Cons (a, next (a + b + i) b) in
  next

let () =
  let show (s, a, b, i) =
    seq_leonardo i b a |> Seq.take 25
    |> Seq.fold_left (Printf.sprintf "%s %u") (Printf.sprintf "First 25 %s numbers:\n" s)
    |> print_endline
  in
  List.iter show ["Leonardo", 1, 1, 1; "Fibonacci", 0, 1, 0]
