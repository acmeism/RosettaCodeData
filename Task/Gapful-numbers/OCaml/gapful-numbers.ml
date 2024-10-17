let rec first_digit x =
  if x < 10 then x else first_digit (x / 10)

let is_gapful x =
  x mod (10 * first_digit x + x mod 10) = 0

let fmt_seq x n =
  Seq.(ints x |> filter is_gapful |> take n |> map string_of_int)
  |> List.of_seq |> String.concat ", "

let () =
  let fmt (x, n) =
    Printf.printf "\nFirst %u gapful numbers from %u:\n%s\n" n x (fmt_seq x n)
  in
  List.iter fmt [100, 30; 1000000, 15; 1000000000, 10]
