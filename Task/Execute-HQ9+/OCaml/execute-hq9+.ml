let hq9p line =
  let accumulator = ref 0 in
  for i = 0 to (String.length line - 1) do
    match line.[i] with
    | 'h' | 'H' -> print_endline "Hello, world!"
    | 'q' | 'Q' -> print_endline line
    | '9' -> beer 99
    | '+' -> incr accumulator
  done
