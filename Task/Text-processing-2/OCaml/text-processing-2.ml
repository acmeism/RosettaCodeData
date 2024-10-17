#load "str.cma"
open Str

let strip_cr str =
  let last = pred (String.length str) in
  if str.[last] <> '\r' then str else String.sub str 0 last

let map_records =
  let rec aux acc = function
    | value::flag::tail ->
        let e = (float_of_string value, int_of_string flag) in
        aux (e::acc) tail
    | [_] -> invalid_arg "invalid data"
    | [] -> List.rev acc
  in
  aux [] ;;

let duplicated_dates =
  let same_date (d1,_) (d2,_) = (d1 = d2) in
  let date (d,_) = d in
  let rec aux acc = function
    | a::b::tl when same_date a b ->
        aux (date a::acc) tl
    | _::tl ->
        aux acc tl
    | [] ->
        List.rev acc
  in
  aux [] ;;

let record_ok (_,record) =
  let is_ok (_,v) = v >= 1 in
  let sum_ok =
    List.fold_left (fun sum this ->
      if is_ok this then succ sum else sum) 0 record
  in
  sum_ok = 24

let num_good_records =
  List.fold_left  (fun sum record ->
    if record_ok record then succ sum else sum) 0 ;;

let parse_line line =
  let li = split (regexp "[ \t]+") line in
  let records = map_records (List.tl li)
  and date = List.hd li in
  (date, records)

let () =
  let ic = open_in "readings.txt" in
  let rec read_loop acc =
    let line_opt = try Some (strip_cr (input_line ic))
                   with End_of_file -> None
    in
    match line_opt with
      None -> close_in ic; List.rev acc
    | Some line -> read_loop (parse_line line :: acc)
  in
  let inputs = read_loop [] in

  Printf.printf "%d total lines\n" (List.length inputs);

  Printf.printf "duplicated dates:\n";
  let dups = duplicated_dates inputs in
  List.iter print_endline dups;

  Printf.printf "number of good records: %d\n" (num_good_records inputs);
;;
