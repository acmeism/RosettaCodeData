let seq_stern_brocot =
  let rec next x xs () =
    match xs () with
    | Seq.Nil -> assert false
    | Cons (x', xs') -> Seq.Cons (x' + x, Seq.cons x' (next x' xs'))
  in
  let rec tail () = Seq.Cons (1, next 1 tail) in
  Seq.cons 1 tail
