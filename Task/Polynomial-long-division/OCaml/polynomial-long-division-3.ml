let str_poly l =
  let term v p = match (v, p) with
    | (  _, 0) -> string_of_float v
    | (1.0, 1) -> "x"
    | (  _, 1) -> (string_of_float v) ^ "*x"
    | (1.0, _) -> "x^" ^ (string_of_int p)
    | _ -> (string_of_float v) ^ "*x^" ^ (string_of_int p) in
  let rec terms = function
    | [] -> []
    | h :: t ->
       if h = 0.0 then (terms t) else (term h (List.length t)) :: (terms t) in
  String.concat " + " (terms l)
