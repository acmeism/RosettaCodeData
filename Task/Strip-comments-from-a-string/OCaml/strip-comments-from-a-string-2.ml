let strip_comments =
  let print = ref true in
  String.iter (function
    | ';' | '#' -> print := false
    | '\n' -> print_char '\n'; print := true
    | c -> if !print then print_char c)
