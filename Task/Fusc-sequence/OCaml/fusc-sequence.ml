let seq_fusc =
  let rec next x xs () =
    match xs () with
    | Seq.Nil -> assert false
    | Cons (x', xs') -> Seq.Cons (x' + x, Seq.cons x' (next x' xs'))
  in
  let rec tail () = Seq.Cons (1, next 1 tail) in
  Seq.cons 0 (Seq.cons 1 tail)

let seq_first_of_lengths =
  let rec next i l sq () =
    match sq () with
    | Seq.Nil -> Seq.Nil
    | Cons (x, xs) when x >= l -> Cons ((i, x), next (succ i) (10 * l) xs)
    | Cons (_, xs) -> next (succ i) l xs ()
  in next 0 10

let () =
  seq_fusc |> Seq.take 61 |> Seq.iter (Printf.printf " %u") |> print_newline
and () =
  seq_fusc |> seq_first_of_lengths |> Seq.take 7
  |> Seq.iter (fun (i, x) -> Printf.printf "%9u @ %u%!\n" x i)
