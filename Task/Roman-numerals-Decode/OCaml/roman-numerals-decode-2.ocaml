(* Scan the roman number from right to left. *)
(* When processing a roman digit, if the previously processed roman digit was
 * greater than the current one, we must substract the latter from the current
 * total, otherwise add it.
 * Example:
 * - MCMLXX read from right to left is XXLMCM
 *          the sum is 10 + 10 + 50 + 1000 - 100 + 1000 *)
let decimal_of_roman roman =
  (* Use 'String.uppercase' for OCaml 4.02 and previous. *)
  let rom = String.uppercase_ascii roman in
  (* A simple association list. IMHO a Hashtbl is a bit overkill here. *)
  let romans = List.combine ['I'; 'V'; 'X'; 'L'; 'C'; 'D'; 'M']
                            [1; 5; 10; 50; 100; 500; 1000] in
  let compare x y =
    if x < y then -1 else 1
  in
  (* Scan the string from right to left using index i, and keeping track of
   * the previously processed roman digit in prevdig. *)
  let rec doloop i prevdig =
    if i < 0 then 0
    else
      try
        let currdig = List.assoc rom.[i] romans in
        (currdig * compare currdig prevdig) + doloop (i - 1) currdig
      with
        (* Ignore any incorrect roman digit and just process the next one. *)
        Not_found -> doloop (i - 1) 0
  in
  doloop (String.length rom - 1) 0


(* Some simple tests. *)
let () =
  let testit roman decimal =
    let conv = decimal_of_roman roman in
    let status = if conv = decimal then "PASS" else "FAIL" in
    Printf.sprintf "[%s] %s\tgives %d.\tExpected: %d.\t"
                   status roman conv decimal
  in
  print_endline ">>> Usual roman numbers.";
  print_endline (testit "MCMXC" 1990);
  print_endline (testit "MMVIII" 2008);
  print_endline (testit "MDCLXVI" 1666);
  print_newline ();

  print_endline ">>> Roman numbers with lower case letters are OK.";
  print_endline (testit "McmXC" 1990);
  print_endline (testit "MMviii" 2008);
  print_endline (testit "mdCLXVI" 1666);
  print_newline ();

  print_endline ">>> Incorrect roman digits are ignored.";
  print_endline (testit "McmFFXC" 1990);
  print_endline (testit "MMviiiPPPPP" 2008);
  print_endline (testit "mdCLXVI_WHAT_NOW" 1666);
  print_endline (testit "2 * PI ^ 2" 1);  (* The I in PI... *)
  print_endline (testit "E = MC^2" 1100)
