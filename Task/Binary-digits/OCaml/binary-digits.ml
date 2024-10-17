let bin_of_int d =
  let last_digit n = [|"0"; "1"|].(n land 1) in
  let rec aux lst = function
    | 0 -> lst
    | n -> aux (last_digit n :: lst) (n lsr 1)
  in
  String.concat "" (aux [last_digit d] (d lsr 1))

(* test *)
let () = [0; 1; 2; 5; 50; 9000; -5]
  |> List.map bin_of_int |> String.concat ", " |> print_endline
