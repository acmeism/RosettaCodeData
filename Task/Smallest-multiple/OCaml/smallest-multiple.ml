let rec gcd a = function
  | 0 -> a
  | b -> gcd b (a mod b)

let lcm a b =
  a * b / gcd a b

let smallest_multiple n =
  Seq.(ints 1 |> take n |> fold_left lcm 1)

let () =
  Printf.printf "%u\n" (smallest_multiple 20)
