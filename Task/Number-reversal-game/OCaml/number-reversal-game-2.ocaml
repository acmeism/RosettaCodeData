let revert li n =
  let rec aux acc i = function
  | [] -> acc
  | xs when i <= 0 -> acc @ xs
  | x::xs -> aux (x::acc) (pred i) xs
  in
  aux [] n li

let take li n =
  let rec aux acc i = function
  | x::xs when i = n -> (x, List.rev_append acc xs)
  | x::xs -> aux (x::acc) (succ i) xs
  | _ -> invalid_arg "take"
  in
  aux [] 0 li

let shuffle li =
  let rec aux acc len = function
  | [] -> acc
  | li ->
      let x, xs = take li (Random.int len) in
      aux (x::acc) (pred len) xs
  in
  aux [] (List.length li) li

let rec sorted = function
  | [] -> (true)
  | x::y::_ when x > y -> (false)
  | x::xs -> sorted xs

let () =
  print_endline "\
  Number Reversal Game
  Sort the numbers in ascending order by repeatedly
  flipping sets of numbers from the left.";
  Random.self_init();
  let li = shuffle [1; 2; 3; 4; 5; 6; 7; 8; 9] in
  let rec loop n li =
    Printf.printf "#%2d: " n;
    List.iter (Printf.printf " %d") li;
    Printf.printf "  ? %!";
    let r = read_int() in
    let li = revert li r in
    if not(sorted li)
    then loop (succ n) li
    else Printf.printf "You took %d attempts to put the digits in order.\n" n;
  in
  loop 1 li
;;
