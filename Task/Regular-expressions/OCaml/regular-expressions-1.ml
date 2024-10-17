#load "str.cma";;
let str = "I am a string";;
try
  ignore(Str.search_forward (Str.regexp ".*string$") str 0);
  print_endline "ends with 'string'"
with Not_found -> ()
;;
