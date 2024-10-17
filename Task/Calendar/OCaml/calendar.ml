#load "unix.cma"

let lang = "en"  (* language: English *)

let usage () =
  Printf.printf "Usage:\n%s\n" Sys.argv.(0)

let month_pattern =
  [
    [  0;  4;  8 ];
    [  1;  5;  9 ];
    [  2;  6; 10 ];
    [  3;  7; 11 ];

    (*
    [  0;  1;  2;  3;  4;  5 ];
    [  6;  7;  8;  9; 10; 11 ];

    [  0;  1;  2;  3 ];
    [  4;  5;  6;  7 ];
    [  8;  9; 10; 11 ];
    *)
  ]

let month_langs = [
  "en", [|
    "January"; "February"; "March"; "April";
    "May"; "June"; "July"; "August"; "September";
    "October"; "November"; "December";
  |];
  "fr", [|
    "janvier"; "février"; "mars"; "avril"; "mai";
    "juin"; "juillet"; "août"; "septembre";
    "octobre"; "novembre"; "décembre";
  |];
]

let days_lang = [
  "en", [| "Monday"; "Tuesday"; "Wednesday";
    "Thursday"; "Friday"; "Saturday"; "Sunday" |];
  "fr", [| "lundi"; "mardi"; "mercredi";
    "jeudi"; "vendredi"; "samedi"; "dimanche" |];
]

let titles_lang = [
  "en", "( Snoopy's best pic )";
  "fr", "( Le meilleur profil de Snoopy )";
]

let days = List.assoc lang days_lang
let month = List.assoc lang month_langs
let title = List.assoc lang titles_lang

let monday_first = 6, [| 0; 1; 2; 3; 4; 5; 6 |]
let sunday_first = 0, [| 6; 0; 1; 2; 3; 4; 5 |]

let off, days_order = sunday_first
let off, days_order = monday_first


let shorten n s =
  let len = String.length s in
  if n >= len then s else
    let n = if s.[n-1] = '\xC3' then n+1 else n in
    if n >= len then s else
      (String.sub s 0 n)


let pad size c s =
  let len = String.length s in
  let n1 = (size - len) / 2 in
  let n2 = size - len - n1 in
  String.make n1 c ^ s ^
  String.make n2 c


let days = Array.map (shorten 2) days


let indices ofs =
  (ofs / 7, ofs mod 7)


let t_same t1 t2 =
  ( t1.Unix.tm_year = t2.Unix.tm_year &&
    t1.Unix.tm_mon  = t2.Unix.tm_mon &&
    t1.Unix.tm_mday = t2.Unix.tm_mday )


let current_year () =
  let t = Unix.localtime (Unix.time ()) in
  (t.Unix.tm_year + 1900)


let make_month t year month =
  let empty_day = 0 in
  let m = Array.make_matrix 6 7 empty_day in
  let ofs = ref 0 in
  for day = 1 to 31 do
    let tm =
      { t with
        Unix.tm_year = year - 1900;
        Unix.tm_mon = month;
        Unix.tm_mday = day;
      }
    in
    let _, this = Unix.mktime tm in
    if !ofs = 0 then ofs := (this.Unix.tm_wday + off) mod 7;
    if t_same this tm then
      let i, j = indices !ofs in
      m.(i).(j) <- day;
    incr ofs;
  done;
  (m)


let cal ~year =
  let empty = [| [| |] |] in
  let months = Array.make 12 empty in
  let t = Unix.gmtime 0.0 in
  for mon = 0 to 11 do
    months.(mon) <- make_month t year mon;
  done;
  (months)


let print_month_label mp =
  List.iter (fun i ->
    let mon = pad 20 ' ' month.(i) in
    Printf.printf " %s " mon
  ) mp;
  print_newline ()


let print_day_label mp =
  List.iter (fun _ ->
    Array.iter (fun i ->
      Printf.printf " %s" days.(i)
    ) days_order
    ; print_string " "
  ) mp;
  print_newline ()


let print_mon m mp =
  print_month_label mp;
  print_day_label mp;
  for w = 0 to pred 6 do
    print_string begin
      String.concat " " begin
        List.map (fun i ->
          let b = Buffer.create 132 in
          for d = 0 to pred 7 do
            match m.(i).(w).(d) with
            | 0 -> Buffer.add_string b "   "
            | d -> Printf.kprintf (Buffer.add_string b) " %2d" d
          done;
          (Buffer.contents b)
        ) mp
      end
    end
    ; print_string "\n"
  done


let print_cal ~y:m =
  List.iter (fun mon_row ->
    print_mon m mon_row
  ) month_pattern


let print_header lbl =
  let n = List.length (List.hd month_pattern) in
  let year_lbl = pad (23*n-7) ' ' lbl in
  Printf.printf " %s\n" year_lbl


let print_calendar ~year =
  print_header title;
  print_header (string_of_int year);
  print_cal (cal ~year)


let () =
  let args = List.tl (Array.to_list Sys.argv) in
  match args with
  | [] ->
      let year = current_year () in
      print_calendar ~year

  | ["--year"; _year] ->
      let year = int_of_string _year in
      print_calendar ~year

  | _ ->
      usage ()
