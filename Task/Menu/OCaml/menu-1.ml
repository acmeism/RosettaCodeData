let select ?(prompt="Choice? ") = function
  | [] -> ""
  | choices ->
      let rec menu () =
        List.iteri (Printf.printf "%d: %s\n") choices;
        print_string prompt;
        try List.nth choices (read_int ())
        with _ -> menu ()
      in menu ()
