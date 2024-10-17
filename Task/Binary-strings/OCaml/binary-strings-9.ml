# #load "str.cma";;
# let replace str occ by =
    Str.global_replace (Str.regexp_string occ) by str
  ;;
val replace : string -> string -> string -> string = <fun>
# replace "The white dog let out a single, loud bark." "white" "black" ;;
- : string = "The black dog let out a single, loud bark."
