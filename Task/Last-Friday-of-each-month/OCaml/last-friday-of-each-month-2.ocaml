open CalendarLib

let usage() =
  Printf.eprintf "%s <year>\n" Sys.argv.(0);
  exit 1

let print_date (year, month, day) =
  Printf.printf "%d-%02d-%02d\n" year month day

let () =
  let year =
    try int_of_string Sys.argv.(1)
    with _ -> usage()
  in
  let fridays = ref [] in
  for month = 1 to 12 do
    let num_days = Date.days_in_month (Date.make_year_month year month) in
    let rec aux day =
      if Date.day_of_week (Date.make year month day) = Date.Fri
      then fridays := (year, month, day) :: !fridays
      else aux (pred day)
    in
    aux num_days
  done;
  List.iter print_date (List.rev !fridays)
