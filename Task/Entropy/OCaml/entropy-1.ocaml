module CharMap = Map.Make(Char)

let entropy s =
  let count map c =
    CharMap.update c (function Some n -> Some (n +. 1.) | None -> Some 1.) map
  and calc _ n sum =
    sum +. n *. Float.log2 n
  in
  let sum = CharMap.fold calc (String.fold_left count CharMap.empty s) 0.
  and len = float (String.length s) in
  Float.log2 len -. sum /. len

let () =
  entropy "1223334444" |> string_of_float |> print_endline
