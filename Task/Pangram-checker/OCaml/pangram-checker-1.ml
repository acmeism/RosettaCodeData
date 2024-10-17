let pangram str =
  let ar = Array.make 26 false in
  String.iter (function
  | 'a'..'z' as c -> ar.(Char.code c - Char.code 'a') <- true
  | _ -> ()
  ) (String.lowercase str);
  Array.fold_left ( && ) true ar
