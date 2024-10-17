let rot13 c = match c with
  | 'A'..'M' | 'a'..'m' -> char_of_int (int_of_char c + 13)
  | 'N'..'Z' | 'n'..'z' -> char_of_int (int_of_char c - 13)
  | _ -> c
