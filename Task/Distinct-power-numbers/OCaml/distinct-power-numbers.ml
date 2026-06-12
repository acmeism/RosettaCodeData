module IntSet = Set.Make(Int)

let pow x =
  let rec aux acc b = function
    | 0 -> acc
    | y -> aux (if y land 1 = 0 then acc else acc * b) (b * b) (y lsr 1)
  in
  aux 1 x

let distinct_powers first count =
  let sq = Seq.(take count (ints first)) in
    IntSet.of_seq (Seq.map_product pow sq sq)

let () = distinct_powers 2 4
  (* output *)
  |> IntSet.to_seq |> Seq.map string_of_int
  |> List.of_seq |> String.concat " " |> print_endline
