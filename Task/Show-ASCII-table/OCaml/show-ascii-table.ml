let show_char i =
  Printf.printf "%5u: %s" i (match i with 32 -> "SPC" | 127 -> "DEL"
    | _ -> Printf.sprintf " %c " (char_of_int i))

let () =
  for i = 32 to 47 do
    for j = 0 to 5 do show_char (j lsl 4 + i) done |> print_newline
  done
