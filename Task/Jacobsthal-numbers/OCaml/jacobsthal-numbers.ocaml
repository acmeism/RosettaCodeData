let is_prime n =
  let rec test x =
    x * x > n || n mod x <> 0 && n mod (x + 2) <> 0 && test (x + 6)
  in
  if n < 5
  then n land 2 <> 0
  else n land 1 <> 0 && n mod 3 <> 0 && test 5

let seq_jacobsthal =
  let rec next b a () = Seq.Cons (a, next (a + a + b) b) in
  next 1

let seq_jacobsthal_oblong =
  let rec next b a () = Seq.Cons (a * b, next (a + a + b) b) in
  next 1 0

let () =
  let show (n, seq, s) =
    Seq.take n seq
    |> Seq.fold_left (Printf.sprintf "%s %u") (Printf.sprintf "First %u %s numbers:\n" n s)
    |> print_endline
  in
  List.iter show [
    30, seq_jacobsthal 0, "Jacobsthal";
    30, seq_jacobsthal 2, "Jacobsthal-Lucas";
    20, seq_jacobsthal_oblong, "Jacobsthal oblong";
    10, Seq.filter is_prime (seq_jacobsthal 0), "Jacobsthal prime"]
