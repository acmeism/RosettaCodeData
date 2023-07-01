let rec loop () =
  print_string "Prompt? [Y/N]: "; flush stdout;
  loop
    @@ print_endline
    @@ match getchar () with
         | 'n' | 'N' -> raise Exit
         | 'y' | 'Y' -> ": Ok."
         | _ -> ": Invalid."

let _ = try loop @@ prompt true with Exit | End_of_file -> prompt false
