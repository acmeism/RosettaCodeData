let is_harshad x =
  let rec dsum n = if n < 10 then n else dsum (n / 10) + n mod 10 in
  x mod dsum x = 0

let () =
  let print_seq (x, n) =
    Seq.(ints x |> filter is_harshad |> take n |> map string_of_int)
    |> List.of_seq |> String.concat ", " |> print_endline
  in
  List.iter print_seq [1, 20; 1001, 1]
