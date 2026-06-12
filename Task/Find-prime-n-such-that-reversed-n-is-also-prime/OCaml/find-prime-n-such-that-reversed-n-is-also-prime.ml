let int_reverse =
  let rec loop m n =
    if n < 10 then m + n else loop ((m + n mod 10) * 10) (n / 10)
  in loop 0

let is_prime n =
  let not_divisible x = n mod x <> 0 in
  seq_primes |> Seq.take_while (fun x -> x * x <= n) |> Seq.for_all not_divisible

let () =
  seq_primes |> Seq.filter (fun p -> is_prime (int_reverse p))
  |> Seq.take_while ((>) 500) |> Seq.iter (Printf.printf " %u") |> print_newline
