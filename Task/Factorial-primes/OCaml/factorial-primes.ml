let is_prime (_, n, _) =
  let rec test x =
    let d = n / x in x > d || x * d <> n && n mod (x + 2) <> 0 && test (x + 6)
  in
  if n < 5
  then n lor 1 = 3
  else n land 1 <> 0 && n mod 3 <> 0 && test 5

let factorials_plus_minus_one =
  let rec next x y () =
    Seq.Cons ((x, pred y, 0), Seq.cons (x, succ y, 1) (next (succ x) (succ x * y)))
  in
  next 1 1

let () =
  let show (x, y, a) = Printf.printf "%3u! %c 1 = %u\n" x [|'-'; '+'|].(a) y in
  factorials_plus_minus_one |> Seq.filter is_prime |> Seq.take 10 |> Seq.iter show
