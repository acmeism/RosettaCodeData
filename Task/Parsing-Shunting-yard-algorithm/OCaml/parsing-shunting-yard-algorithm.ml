type associativity = Left | Right;;


let prec op =
  match op with
  | "^" -> 4
  | "*" -> 3
  | "/" -> 3
  | "+" -> 2
  | "-" -> 2
  | _ -> -1;;


let assoc op =
  match op with
  | "^" -> Right
  | _ -> Left;;


let split_while p =
  let rec go ls xs =
    match xs with
    | x::xs' when p x -> go (x::ls) xs'
    | _ -> List.rev ls, xs
  in go [];;


let rec intercalate sep xs =
  match xs with
  | [] -> ""
  | [x] -> x
  | x::xs' -> x ^ sep ^ intercalate sep xs';;


let shunting_yard =
  let rec pusher stack queue tkns =
    match tkns with
    | [] -> List.rev queue @ stack
    | "("::tkns' -> pusher ("("::stack) queue tkns'
    | ")"::tkns' ->
        let mv, "("::stack' = split_while ((<>) "(") stack in
        pusher stack' (mv @ queue) tkns'
    | t::tkns' when prec t < 0 -> pusher stack (t::queue) tkns'
    | op::tkns' ->
        let mv_to_queue op2 =
          (match assoc op with
            | Left -> prec op <= prec op2
            | Right -> prec op < prec op2)
        in
        let mv, stack' = split_while mv_to_queue stack in
        pusher (op::stack') (mv @ queue) tkns'
  in pusher [] [];;


let () =
  let inp = read_line () in
  let tkns = String.split_on_char ' ' inp in
  let postfix = shunting_yard tkns in
  print_endline (intercalate " " postfix);;
