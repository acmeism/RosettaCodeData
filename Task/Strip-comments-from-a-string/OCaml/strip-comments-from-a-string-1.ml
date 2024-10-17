let strip_comments str =
  let len = String.length str in
  let rec aux print i =
    if i >= len then () else
    match str.[i] with
    | '#' | ';' ->
        aux false (succ i)
    | '\n' ->
        print_char '\n';
        aux true (succ i)
    | c ->
        if print then print_char c;
        aux print (succ i)
  in
  aux true 0

let () =
  strip_comments "apples, pears # and bananas\n";
  strip_comments "apples, pears ; and bananas\n";
;;
