let random_seq seed =
  let next x = x * x / 1000 mod 1000_000 in
  Seq.iterate next (next seed)

(* test *)
let () =
  random_seq 675248 |> Seq.take 5 |> Seq.iter (Printf.printf " %u")
