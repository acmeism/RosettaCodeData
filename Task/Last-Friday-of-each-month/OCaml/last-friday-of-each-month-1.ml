#load "unix.cma"
open Unix

let usage() =
  Printf.eprintf "%s <year>\n" Sys.argv.(0);
  exit 1

let print_date t =
  Printf.printf "%d-%02d-%02d\n" (t.tm_year + 1900) (t.tm_mon + 1) t.tm_mday

let is_date_ok tm t =
  (tm.tm_year = t.tm_year &&
   tm.tm_mon  = t.tm_mon  &&
   tm.tm_mday = t.tm_mday)

let () =
  let _year =
    try int_of_string Sys.argv.(1)
    with _ -> usage()
  in
  let year = _year - 1900 in
  let fridays = Array.make 12 (Unix.gmtime 0.0) in
  for month = 0 to 11 do
    for day_of_month = 1 to 31 do
      let tm = { (Unix.gmtime 0.0) with
        tm_year = year;
        tm_mon = month;
        tm_mday = day_of_month;
      } in
      let _, t = Unix.mktime tm in
      if is_date_ok tm t  (* check for months that have less than 31 days *)
      && t.tm_wday = 5  (* is a friday *)
      then fridays.(month) <- t
    done;
  done;
  Array.iter print_date fridays
