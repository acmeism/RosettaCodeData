let rec gcd a = function
  | 0 -> a
  | b -> gcd b (a mod b)

let seq_index_of el =
  let rec next i sq =
    match sq () with
    | Seq.Nil -> 0
    | Cons (e, sq') -> if e = el then i else next (succ i) sq'
  in
  next 1

let seq_map_pairwise f sq =
  match sq () with
  | Seq.Nil -> Seq.empty
  | Cons (_, sq') -> Seq.map2 f sq sq'

let () =
  seq_stern_brocot |> Seq.take 15 |> Seq.iter (Printf.printf " %u") |> print_newline
and () =
  List.iter
    (fun n -> seq_stern_brocot |> seq_index_of n |> Printf.printf " %u@%u" n)
    [1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 100]
  |> print_newline
and () =
  seq_stern_brocot |> Seq.take 1000 |> seq_map_pairwise gcd |> Seq.for_all ((=) 1)
  |> Printf.printf " %B\n"
