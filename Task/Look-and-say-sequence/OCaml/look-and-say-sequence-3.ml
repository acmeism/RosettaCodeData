#load "str.cma";;

let lookandsay =
  Str.global_substitute (Str.regexp "\\(.\\)\\1*")
                        (fun s -> string_of_int (String.length (Str.matched_string s)) ^
                                  Str.matched_group 1 s)

let () =
  let num = ref "1" in
  print_endline !num;
  for i = 1 to 10 do
    num := lookandsay !num;
    print_endline !num;
  done
