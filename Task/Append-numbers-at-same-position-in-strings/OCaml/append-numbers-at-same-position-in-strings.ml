let lists = [
  ["1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"];
  ["10"; "11"; "12"; "13"; "14"; "15"; "16"; "17"; "18"];
  ["19"; "20"; "21"; "22"; "23"; "24"; "25"; "26"; "27"]]

let reduce f = function
  | h :: t -> List.fold_left f h t
  | _ -> invalid_arg "reduce"

let () =
  reduce (List.map2 (^)) lists |> String.concat ", " |> print_endline
