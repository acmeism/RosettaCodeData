let int_of_basen n str =
  match n with
  | 16 -> int_of_string("0x" ^ str)
  |  2 -> int_of_string("0b" ^ str)
  |  8 -> int_of_string("0o" ^ str)
  | _ -> failwith "unhandled"

let basen_of_int n d =
  match n with
  | 16 -> Printf.sprintf "%x" d
  |  8 -> Printf.sprintf "%o" d
  | _ -> failwith "unhandled"
