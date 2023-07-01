let show_nth n =
  if (n mod 10 = 1) && (n mod 100 <> 11) then "st"
  else if (n mod 10 = 2) && (n mod 100 <> 12) then "nd"
  else if (n mod 10 = 3) && (n mod 100 <> 13) then "rd"
  else "th"


let () =
  let show_ordinals (min, max) =
    for i=min to max do
      Printf.printf "%d%s " i (show_nth i)
    done;
    print_newline() in

  List.iter show_ordinals [ (0,25); (250,265); (1000,1025) ]
