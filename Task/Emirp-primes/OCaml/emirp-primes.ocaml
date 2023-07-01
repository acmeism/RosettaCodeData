let int_reverse =
  let rec loop m n =
    if n < 10 then m + n else loop ((m + n mod 10) * 10) (n / 10)
  in loop 0

let is_prime n =
  let not_divisible x = n mod x <> 0 in
  seq_primes |> Seq.take_while (fun x -> x * x <= n) |> Seq.for_all not_divisible

let seq_emirps =
  let is_emirp n = let m = int_reverse n in m <> n && is_prime m in
  seq_primes |> Seq.filter is_emirp

let () =
  let seq_show sq = print_newline (Seq.iter (Printf.printf " %u") sq) in
  seq_emirps |> Seq.take 20 |> seq_show;
  seq_emirps |> Seq.drop_while ((>) 7700) |> Seq.take_while ((>) 8000) |> seq_show;
  seq_emirps |> Seq.drop 9999 |> Seq.take 1 |> seq_show
