let rec insert lst x =
  match lst with
  | y :: ys when x > y -> y :: insert ys x
  | _ -> x :: lst

let insertion_sort = List.fold_left insert []

let () = [6; 8; 5; 9; 3; 2; 1; 4; 7]
  |> insertion_sort |> List.iter (Printf.printf " %u") |> print_newline
