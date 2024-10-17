#load "str.cma"
#load "nums.cma"  (* for module Big_int *)


(* Countries and length of their IBAN. *)
(* Taken from https://en.wikipedia.org/wiki/International_Bank_Account_Number#IBAN_formats_by_country *)
let countries = [
  ("AL", 28); ("AD", 24); ("AT", 20); ("AZ", 28); ("BH", 22); ("BE", 16);
  ("BA", 20); ("BR", 29); ("BG", 22); ("CR", 21); ("HR", 21); ("CY", 28);
  ("CZ", 24); ("DK", 18); ("DO", 28); ("TL", 23); ("EE", 20); ("FO", 18);
  ("FI", 18); ("FR", 27); ("GE", 22); ("DE", 22); ("GI", 23); ("GR", 27);
  ("GL", 18); ("GT", 28); ("HU", 28); ("IS", 26); ("IE", 22); ("IL", 23);
  ("IT", 27); ("JO", 30); ("KZ", 20); ("XK", 20); ("KW", 30); ("LV", 21);
  ("LB", 28); ("LI", 21); ("LT", 20); ("LU", 20); ("MK", 19); ("MT", 31);
  ("MR", 27); ("MU", 30); ("MC", 27); ("MD", 24); ("ME", 22); ("NL", 18);
  ("NO", 15); ("PK", 24); ("PS", 29); ("PL", 28); ("PT", 25); ("QA", 29);
  ("RO", 24); ("SM", 27); ("SA", 24); ("RS", 22); ("SK", 24); ("SI", 19);
  ("ES", 24); ("SE", 24); ("CH", 21); ("TN", 24); ("TR", 26); ("AE", 23);
  ("GB", 22); ("VG", 24); ("DZ", 24); ("AO", 25); ("BJ", 28); ("BF", 27);
  ("BI", 16); ("CM", 27); ("CV", 25); ("IR", 26); ("CI", 28); ("MG", 27);
  ("ML", 28); ("MZ", 25); ("SN", 28); ("UA", 29)
]
(* Put the countries in a Hashtbl for faster search... *)
let tbl_countries =
  let htbl = Hashtbl.create (List.length countries) in
  let _ = List.iter (fun (k, v) -> Hashtbl.add htbl k v) countries in
  htbl


(* Delete spaces and put all letters in upper case. *)
let clean_iban iban =
  Str.global_replace (Str.regexp " +") "" iban
  |> String.uppercase_ascii


(* Each country has an IBAN with a specific length. *)
let check_length ib =
  let iso_length = List.hd countries |> fst |> String.length in
  let country_code = String.sub ib 0 iso_length in
  try
    Hashtbl.find tbl_countries country_code = String.length ib
  with
    Not_found -> false


(* Convert a string into a list of chars. *)
let charlist_of_string s =
  let l = String.length s in
  let rec doloop i =
    if i >= l then []
    else s.[i] :: doloop (i + 1)
  in
  doloop 0


(* Letters are associated to values: A=10, B=11, ..., Z=35. *)
let val_of_char c =
  match c with
  | '0' .. '9' -> int_of_char c - int_of_char '0'
  | 'A' .. 'Z' -> int_of_char c - int_of_char 'A' + 10
  | _ -> failwith (Printf.sprintf "Character not allowed: %c" c)


(* Compute the mod-97 value and check it is equal to 1. *)
let check_mod97 ib =
  let l = String.length ib
  and taken = 4 in
  let prefix = String.sub ib 0 taken
  and rest = String.sub ib taken (l - taken) in
  let newval = rest ^ prefix (* move the 4 initial characters to the end of the string *)
            |> charlist_of_string  (* convert the string into a list of chars *)
            |> List.map val_of_char  (* convert each char into its integer value *)
            |> List.map string_of_int  (* convert the integers into strings... *)
            |> List.fold_left (^) "" in  (* ...and concatenate said strings *)
  (* Now compute the mod-97 using the Big Integers provided by OCaml, and
   * compare the result to 1. *)
  Big_int.eq_big_int
    (Big_int.mod_big_int (Big_int.big_int_of_string newval)
                         (Big_int.big_int_of_int 97))
    (Big_int.big_int_of_int 1)


(* Do the validation as described in the Wikipedia article at
 * https://en.wikipedia.org/wiki/International_Bank_Account_Number#Validating_the_IBAN *)
let validate iban =
  let ib = clean_iban iban in
  check_length ib && check_mod97 ib


let () =
  let ibans = [
    ("GB82 WEST 1234 5698 7654 32", true);
    ("GB82 TEST 1234 5698 7654 32", false);
    ("GB81 WEST 1234 5698 7654 32", false);
    ("GB82 WEST 1234 5698 7654 3", false);
    ("SA03 8000 0000 6080 1016 7519", true);
    ("CH93 0076 2011 6238 5295 7", true);
    ("\"Completely incorrect iban\"", false)
  ] in
  let testit (ib, exp) =
    let res = validate ib in
    Printf.printf "%s is %svalid. Expected %b [%s]\n"
                  ib (if res then "" else "not ")
                  exp (if res = exp then "PASS" else "FAIL")
  in
  List.iter (fun pair -> testit pair) ibans
