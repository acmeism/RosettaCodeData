let modpow m =
  let rec loop p b e =
    if e land 1 = 0
    then if e = 0 then p else loop p (b * b mod m) (e lsr 1)
    else loop (p * b mod m) (b * b mod m) (e lsr 1)
  in loop 1

let is_curzon k n =
  let r = k * n in r = modpow (succ r) k n

let () =
  List.iter (fun x ->
    Seq.(ints 0 |> filter (is_curzon x) |> take 50 |> map string_of_int)
    |> List.of_seq |> String.concat " " |> Printf.printf "base %u:\n%s\n" x)
  [2; 4; 6; 8; 10]

let () =
  List.iter (fun x ->
    Seq.(ints 0 |> filter (is_curzon x) |> drop 999 |> take 1
    |> iter (Printf.printf "base %u (1000th): %u\n" x)))
  [2; 4; 6; 8; 10]
