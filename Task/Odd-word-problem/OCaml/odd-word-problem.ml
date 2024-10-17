let is_alpha c =
  c >= 'a' && c <= 'z' ||
  c >= 'A' && c <= 'Z'

let rec odd () =
  let c = input_char stdin in
  if is_alpha c
  then (let e = odd () in print_char c; e)
  else (c)

let rec even () =
  let c = input_char stdin in
  if is_alpha c
  then (print_char c; even ())
  else print_char c

let rev_odd_words () =
  while true do
    even ();
    print_char (odd ())
  done

let () =
  try rev_odd_words ()
  with End_of_file -> ()
