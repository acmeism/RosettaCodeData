class player (name_init : string) =
  object
    val name = name_init
    val mutable total = 0
    val mutable turn_score = 0
    method get_name = name
    method get_score = total
    method end_turn = total <- total + turn_score;
                      turn_score <- 0;
    method has_won = total >= 100;
    method rolled roll = match roll with
                          1 -> turn_score <- 0;
                         |_ -> turn_score <- turn_score + roll;
  end;;

let print_seperator () =
  print_endline "#####";;

let rec one_turn p1 p2 =
  Printf.printf "What do you want to do %s?\n" p1#get_name;
  print_endline "  1)Roll the dice?";
  print_endline "  2)Or end your turn?";
  let choice = read_int () in
  if choice = 1 then
  begin
    let roll = 1 + Random.int 6 in
      Printf.printf "Rolled a %d\n" roll;
      p1#rolled roll;
      match roll with
        1 -> print_seperator ();
             one_turn p2 p1
       |_ -> one_turn p1 p2
  end
  else if choice = 2 then
  begin
    p1#end_turn;
    match p1#has_won with
     false -> Printf.printf "%s's score is now %d\n" p1#get_name p1#get_score;
               print_seperator();
               one_turn p2 p1;
     |true -> Printf.printf "Congratulations %s! You've won\n" p1#get_name
  end
  else
  begin
    print_endline "That's not a choice! Make a real one!";
    one_turn p1 p2
  end;;

Random.self_init ();
let p1 = new player "Steven"
and p2 = new player "John" in
one_turn p1 p2;;
