#load "str.cma";;

open Str

let encode =
  global_substitute (Str.regexp "\\(.\\)\\1*")
    (fun s -> string_of_int (String.length (matched_string s)) ^
              matched_group 1 s)

let decode =
  global_substitute (Str.regexp "\\([0-9]+\\)\\([^0-9]\\)")
    (fun s -> String.make (int_of_string (matched_group 1 s))
                          (matched_group 2 s).[0])

let () =
  print_endline (encode "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW");
  print_endline (decode "12W1B12W3B24W1B14W");
