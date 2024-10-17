let basen_of_int b n : string =
  let tab = "0123456789abcdefghijklmnopqrstuvwxyz" in
  let rec aux x l =
    if x < b
    then tab.[x] :: l
    else aux (x / b) (tab.[x mod b] :: l)
  in
  String.of_seq (List.to_seq (aux n []))

let basen_to_int b ds : int =
  let of_sym c =
    int_of_char c - match c with
    | '0' .. '9' -> int_of_char '0'
    | 'a' .. 'z' -> int_of_char 'a' - 10
    | 'A' .. 'Z' -> int_of_char 'A' - 10
    | _ -> invalid_arg "unkown digit"
  in
  String.fold_left (fun n d -> n * b + of_sym d) 0 ds
