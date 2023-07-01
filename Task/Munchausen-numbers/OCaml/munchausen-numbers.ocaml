let is_munchausen n =
  let pwr = [|1; 1; 4; 27; 256; 3125; 46656; 823543; 16777216; 387420489|] in
  let rec aux x = if x < 10 then pwr.(x) else aux (x / 10) + pwr.(x mod 10) in
  n = aux n

let () =
  Seq.(ints 1 |> take 5000 |> filter is_munchausen |> iter (Printf.printf " %u"))
  |> print_newline
