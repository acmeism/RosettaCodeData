let divisors = [
  (max_int, "wk");  (* many wk = many wk *)
  (7, "d");         (* 7 d = 1 wk *)
  (24, "hr");       (* 24 hr = 1 d *)
  (60, "min");      (* 60 min = 1 hr *)
  (60, "sec")       (* 60 sec = 1 min *)
]


(* Convert a number of seconds into a list of values for weeks, days, hours,
 * minutes and seconds, by dividing the number of seconds 'secs' successively by
 * the values contained in the list 'divisors' (taking them in reverse order).
 * Ex:
 *     compute_duration 7259
 * returns
 *     [(0, "wk"); (0, "d"); (2, "hr") (0, "min"); (59, "sec")]
 *)
let compute_duration secs =
  let rec doloop remain res = function
    | [] -> res
    | (n, s) :: ds -> doloop (remain / n) ((remain mod n, s) :: res) ds
  in
  doloop secs [] (List.rev divisors)


(* Format nicely the list of values.
 * Ex:
 *     pretty_print [(0, "wk"); (0, "d"); (2, "hr") (0, "min"); (59, "sec")]
 * returns
 *     "2 hr, 59 sec"
 *
 * Intermediate steps:
 * 1. Keep only the pairs where duration is not 0
 *     [(2, "hr"); (59, "sec")]
 * 2. Format each pair as a string
 *     ["2 hr"; "59 sec"]
 * 3. Concatenate the strings separating them by a comma+space
 *     "2 hr, 59 sec"
 *)
let pretty_print dur =
  List.filter (fun (d, _) -> d <> 0) dur
  |> List.map (fun (d, l) -> Printf.sprintf "%d %s" d l)
  |> String.concat ", "


(* Transform a number of seconds into the corresponding compound duration
 * string.
 * Not sure what to do with 0... *)
let compound = function
  | n when n > 0 -> compute_duration n |> pretty_print
  | n when n = 0 -> string_of_int 0 ^ "..."
  | _ -> invalid_arg "Number of seconds must be positive"


(* Some testing... *)
let () =
  let test_cases = [
    (7259, "2 hr, 59 sec");
    (86400, "1 d");
    (6000000, "9 wk, 6 d, 10 hr, 40 min");
    (0, "0...");
    (3599, "59 min, 59 sec");
    (3600, "1 hr");
    (3601, "1 hr, 1 sec")
  ] in
  let testit (n, s) =
    let calc = compound n in
    Printf.printf "[%s] %d seconds -> %s; expected: %s\n"
                  (if calc = s then "PASS" else "FAIL")
                  n calc s
  in
  List.iter testit test_cases
