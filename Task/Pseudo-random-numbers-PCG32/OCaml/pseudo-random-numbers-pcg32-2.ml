let () =
  pcg32 42L 54L |> seq_pcg32 |> Seq.take 5
  |> Seq.iter (Printf.printf " %lu") |> print_newline

let () =
  pcg32 987654321L 1L |> seq_pcg32 |> Seq.map (int32_bound 5) |> Seq.take 100000
  |> Seq.fold_left (fun a n -> a.(n) <- succ a.(n); a) (Array.make 5 0)
  |> Array.iteri (Printf.printf "%u: %u\n")
