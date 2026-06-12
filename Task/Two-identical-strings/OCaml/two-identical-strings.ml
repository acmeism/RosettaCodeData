let rec bin_of_int = function
  | n when n < 2 -> string_of_int n
  | n -> Printf.sprintf "%s%u" (bin_of_int (n lsr 1)) (n land 1)

let seq_task =
  let rec next n l m () =
    if n = l
    then next n (l + l) (succ (l + l)) ()
    else Seq.Cons (n * m, next (succ n) l m)
  in next 1 2 3

let () =
  let show n = Printf.printf "%u: %s\n" n (bin_of_int n) in
  seq_task |> Seq.take_while ((>) 1000) |> Seq.iter show
