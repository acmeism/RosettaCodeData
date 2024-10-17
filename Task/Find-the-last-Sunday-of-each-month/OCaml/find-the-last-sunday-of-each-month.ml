let is_leap_year y =
  (* See OCaml solution on Rosetta Code for
     determing if it's a leap year *)
  if (y mod 100) = 0
    then (y mod 400) = 0
    else (y mod 4) = 0;;

let get_days y =
  if is_leap_year y
    then
      [31;29;31;30;31;30;31;31;30;31;30;31]
    else
      [31;28;31;30;31;30;31;31;30;31;30;31];;

let print_date = Printf.printf "%d/%d/%d\n";;

let get_day_of_week y m d =
  let y = if m > 2 then y else y - 1 in
  let c = y / 100 in
  let y = y mod 100 in
  let m_shifted = float_of_int ( ((m + 9) mod 12) + 1) in
  let m_factor = int_of_float (2.6 *. m_shifted -. 0.2) in
  let leap_factor = 5 * (y mod 4) + 3 * (y mod 7) + 5 * (c mod 4) in
  (d + m_factor + leap_factor) mod 7;;

let get_shift y m last_day =
  get_day_of_week y m last_day;;

let print_last_sunday y m =
  let days = get_days y in
  let last_day = List.nth days (m - 1) in
  let last_sunday = last_day - (get_shift y m last_day) in
  print_date y m last_sunday;;

let print_last_sundays y =
  let months = [1;2;3;4;5;6;7;8;9;10;11;12] in
  List.iter (print_last_sunday y) months;;

match (Array.length Sys.argv ) with
  2 -> print_last_sundays( int_of_string (Sys.argv.(1)));
 |_ -> invalid_arg "Please enter a year";
