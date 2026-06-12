let () =
  seq_primes |> Seq.drop 10000 |> Seq.take 1 |> Seq.iter (Printf.printf "%u\n")
