module CSet = Set.Make(struct
  type t = char
  let compare = compare
end)

let str2cset str = CSet.add_seq (String.to_seq str) CSet.empty

let has_same_digits n =
  let deci = Format.sprintf "%d" n in
  let hexa = Format.sprintf "%x" n in
  (* Don't use '=' to compare sets, it only returns true
     for sets that are structurally the same, (same elements added in same order)
     use CSet.equal to check they have the same elements *)
  CSet.equal (str2cset deci) (str2cset hexa)

let rec list_similar ?(acc=[]) n =
  if n < 0 then acc
  else if has_same_digits n then list_similar ~acc:(n::acc) (n-1)
  else list_similar ~acc (n-1)

let () =
  let same_digits = list_similar 100_000 in
  List.iteri (fun i x ->
    Format.printf "%6d:%#8x%s" x x (if i mod 6 = 5 then "\n" else "  ")) same_digits;
  print_newline ()
