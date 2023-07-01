let read_line_opt ic =
  try Some (input_line ic)
  with End_of_file -> None

let read_lines ic =
  let rec loop acc =
    match read_line_opt ic with
    | Some line -> loop (line :: acc)
    | None -> (List.rev acc)
  in
  loop []
;;
