(* The Rosetta Code integer square root task, in OCaml, using Zarith
   for large integers.

   Compile with, for example:

      ocamlfind ocamlc -package zarith -linkpkg -o isqrt isqrt.ml

   Translated from the Scheme. *)

let find_a_power_of_4_greater_than_x x =
  let open Z in
  let rec loop q =
    if x < q then q else loop (q lsl 2)
  in
  loop one

let isqrt x =
  let open Z in
  let rec loop q z r =
    if q = one then
      r
    else
      let q = q asr 2 in
      let t = z - r - q in
      let r = r asr 1 in
      if t < zero then
        loop q z r
      else
        loop q t (r + q)
  in
  let q0 = find_a_power_of_4_greater_than_x x in
  let z0 = x in
  let r0 = zero in
  loop q0 z0 r0

let insert_separators s sep =
  let rec loop revchars i newchars =
    match revchars with
    | [] -> newchars
    | revchars when i = 3 -> loop revchars 0 (sep :: newchars)
    | c :: tail -> loop tail (i + 1) (c :: newchars)
  in
  let revchars = List.rev (List.of_seq (String.to_seq s)) in
  String.of_seq (List.to_seq (loop revchars 0 []))

let commas s = insert_separators s ','

let main () =
  Printf.printf "isqrt(i) for 0 <= i <= 65:\n\n";
  for i = 0 to 64 do
    Printf.printf "%s " Z.(to_string (isqrt (of_int i)))
  done;
  Printf.printf "%s\n" Z.(to_string (isqrt (of_int 65)));
  Printf.printf "\n\n";
  Printf.printf "isqrt(7**i) for 1 <= i <= 73, i odd:\n\n";
  Printf.printf "%2s %84s %43s\n" "i" "7**i" "isqrt(7**i)";
  for i = 1 to 131 do Printf.printf "-" done;
  Printf.printf "\n";
  for j = 0 to 36 do
    let i = j + j + 1 in
    let power = Z.(of_int 7 ** i) in
    let root = isqrt power in
    Printf.printf "%2d %84s %43s\n"
      i (commas (Z.to_string power)) (commas (Z.to_string root))
  done
;;

main ()
