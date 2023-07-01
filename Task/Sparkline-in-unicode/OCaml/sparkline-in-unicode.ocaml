let before_first_bar = 0x2580
let num_bars = 8

let sparkline numbers =
  let max_num = List.fold_left max 0. numbers in
  let scale = float_of_int num_bars /. max_num in
  let bars = Buffer.create num_bars in
  let add_bar number =
    let scaled = scale *. number |> Float.round |> int_of_float in
    if scaled <= 0 then
      (* Using underscore character to differentiate between zero and one *)
      Buffer.add_char bars '_'
    else
      scaled + before_first_bar |> Uchar.of_int |> Buffer.add_utf_8_uchar bars
  in
  List.iter add_bar numbers;
  Buffer.contents bars

let print_sparkline line =
  Printf.printf "Numbers: %s\n" line;
  line
  |> String.trim
  |> String.split_on_char ' '
  |> List.map (String.split_on_char ',')
  |> List.flatten
  |> List.filter_map (function
    | "" -> None
    | number -> Some (float_of_string number))
  |> sparkline
  |> print_endline

let () =
  "0 0 1 1; 0 1 19 20; 0 999 4000 4999 7000 7999;
   1 2 3 4 5 6 7 8 7 6 5 4 3 2 1;
   1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5 "
  |> String.trim
  |> String.split_on_char ';'
  |> List.iter print_sparkline
