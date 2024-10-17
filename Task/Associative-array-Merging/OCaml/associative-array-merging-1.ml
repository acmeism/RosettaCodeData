type ty =
    | TFloat of float
    | TInt of int
    | TString of string

type key = string
type assoc = string * ty

let string_of_ty : ty -> string = function
    | TFloat x -> string_of_float x
    | TInt i -> string_of_int i
    | TString s -> s

let print_pair key el =
    Printf.printf "%s: %s\n" key (string_of_ty el)
;;
