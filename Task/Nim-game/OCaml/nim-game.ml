let rec player_turn () =
  print_string "How many tokens would you like to take? ";
  let n = read_int_opt () |> Option.value ~default:0 in
  if n >= 1 && n <= 3 then n
  else (
    print_endline "Number must be between 1 and 3";
    player_turn ())

let computer_turn tokens = tokens mod 4

let plural_suffix = function 1 -> "" | _ -> "s"

let turn_report prefix taken tokens =
  Printf.printf "%s %d token%s.\n%d token%s remaining.\n%!" prefix taken
    (plural_suffix taken) tokens (plural_suffix tokens)

let rec play_game tokens =
  let player_tokens = player_turn () in
  let tokens = tokens - player_tokens in
  turn_report "You take" player_tokens tokens;
  let computer_tokens = computer_turn tokens in
  let tokens = tokens - computer_tokens in
  turn_report "Computer takes" computer_tokens tokens;
  if tokens = 0 then print_endline "Computer wins!" else play_game tokens

let () = play_game 12
