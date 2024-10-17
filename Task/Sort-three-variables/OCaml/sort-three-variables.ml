let sortrefs list =
  let sorted = List.map ( ! ) list
               |> List.sort (fun a b ->
                   if a < b then -1 else
                   if a > b then  1 else
                     0) in
  List.iter2 (fun v x -> v := x) list sorted

open Printf

let test () =
  let x = ref "lions, tigers, and" in
  let y = ref "bears, oh my!" in
  let z = ref "(from the \"Wizard of OZ\")" in
  sortrefs [x; y; z];
  print_endline "case 1:";
  printf "\tx: %s\n" !x;
  printf "\ty: %s\n" !y;
  printf "\tz: %s\n" !z;

  let x = ref 77444 in
  let y = ref (-12) in
  let z = ref 0 in
  sortrefs [x; y; z];
  print_endline "case 1:";
  printf "\tx: %d\n" !x;
  printf "\ty: %d\n" !y;
  printf "\tz: %d\n" !z
