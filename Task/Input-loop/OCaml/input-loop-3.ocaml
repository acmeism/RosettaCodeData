let read_lines f ic =
  let rec loop () =
    try f (input_line ic); loop ()
    with End_of_file -> ()
  in
  loop ()

let () =
  let ic = open_in Sys.argv.(1) in
  read_lines print_endline ic
