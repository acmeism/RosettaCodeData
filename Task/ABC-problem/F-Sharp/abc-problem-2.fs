let blocks = [
  ('B', 'O');  ('X', 'K');  ('D', 'Q');  ('C', 'P');
  ('N', 'A');  ('G', 'T');  ('R', 'E');  ('T', 'G');
  ('Q', 'D');  ('F', 'S');  ('J', 'W');  ('H', 'U');
  ('V', 'I');  ('A', 'N');  ('O', 'B');  ('E', 'R');
  ('F', 'S');  ('L', 'Y');  ('P', 'C');  ('Z', 'M');
]

let find_letter blocks c =
  let found, remaining =
    List.partition (fun (c1, c2) -> c1 = c || c2 = c) blocks
  in
  match found with
  | _ :: res -> Some (res @ remaining)
  | _ -> None

let can_make_word w =
  let n = String.length w in
  let rec aux i _blocks =
    if i >= n then true else
      match find_letter _blocks w.[i] with
      | None -> false
      | Some rem_blocks ->
          aux (i+1) rem_blocks
  in
  aux 0 blocks

let test label f (word, should) =
  printfn "- %s %s = %A  (should: %A)" label word (f word) should

let () =
  List.iter (test "can make word" can_make_word) [
    "A", true;
    "BARK", true;
    "BOOK", false;
    "TREAT", true;
    "COMMON", false;
    "SQUAD", true;
    "CONFUSE", true;
  ]
