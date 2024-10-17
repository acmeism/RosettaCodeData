let multi_fac d n =
  let rec loop a x = if x < 2 then a else loop (a * x) (x - d) in
  loop n (n - d)

let () =
  for i = 1 to 5 do
    Seq.(ints 1 |> take 10 |> map (multi_fac i) |> map string_of_int)
    |> List.of_seq |> String.concat " " |> print_endline
  done
