let lcg31 a c x =
  (a * x + c) land 0x7fffffff

let rng_seq rng seed =
  Seq.iterate rng (rng seed)

let lcg_bsd =
  rng_seq (lcg31 1103515245 12345)

let lcg_ms seed =
  Seq.map (fun r -> r lsr 16) (rng_seq (lcg31 214013 2531011) seed)

(* test code *)
let () =
  let print_first8 sq =
    sq |> Seq.take 8 |> Seq.map string_of_int
    |> List.of_seq |> String.concat " " |> print_endline
  in
  List.iter print_first8 [lcg_bsd 0; lcg_bsd 1; lcg_ms 0; lcg_ms 1]
