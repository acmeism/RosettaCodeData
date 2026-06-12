let rec read_lines_reverse lst =
  match read_line () with
  | line -> read_lines_reverse (line :: lst)
  | exception End_of_file -> lst

let () = read_lines_reverse [] |> List.iter print_endline
