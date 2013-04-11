open CalendarLib

let list_make_seq first last =
  let rec aux i acc =
    if i < first then acc
    else aux (pred i) (i::acc)
  in
  aux last []

let print_date (year, month, day) =
  Printf.printf "%d-%02d-%02d\n" year month day

let () =
  let years = list_make_seq 2008 2121 in
  let years = List.filter (fun year ->
    Date.day_of_week (Date.make year 12 25) = Date.Sun) years in
  print_endline "December 25 is a Sunday in:";
  List.iter (Printf.printf "%d\n") years
