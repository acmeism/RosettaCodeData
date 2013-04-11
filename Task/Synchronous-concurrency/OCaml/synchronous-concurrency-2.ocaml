let reader count_source lines_dest =
  let file = open_in "input.txt" in
  let rec aux () =
    let line = try  Some (input_line file)
               with End_of_file -> None    in
      sync (send lines_dest line);
      match line with
	| Some _ -> aux ()
	| None   -> let printed = sync (receive count_source) in
	    Printf.printf "The task wrote %i strings\n" printed;
	    close_in file
  in aux ()
