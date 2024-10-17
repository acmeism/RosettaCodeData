let seq_show sq =
  print_newline (Seq.iter (Printf.printf " %u") sq)

let () =
  seq_primes |> Seq.take 20 |> seq_show;
  seq_primes |> Seq.drop_while ((>) 100) |> Seq.take_while ((>) 150) |> seq_show;
  seq_primes |> Seq.drop_while ((>) 7700) |> Seq.take_while ((>) 8000)
    |> Seq.length |> Printf.printf " %u primes\n";
  seq_primes |> Seq.drop 9999 |> Seq.take 1 |> seq_show
