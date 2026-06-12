#load "unix.cma"
#load "str.cma"

let colors = [|
  ((15,  0,  0), "31");
  (( 0, 15,  0), "32");
  ((15, 15,  0), "33");
  (( 0,  0, 15), "34");
  ((15,  0, 15), "35");
  (( 0, 15, 15), "36");
|]

let square_dist (r1, g1, b1) (r2, g2, b2) =
  let xd = r2 - r1 in
  let yd = g2 - g1 in
  let zd = b2 - b1 in
  (xd * xd + yd * yd + zd * zd)

let print_color s =
  let n = String.length s in
  let k = ref 0 in
  for i = 0 to pred (n / 3) do
    let j = i * 3 in
    let c1 = s.[j]
    and c2 = s.[j+1]
    and c3 = s.[j+2] in
    k := j+3;
    let rgb =
      int_of_string (Printf.sprintf "0x%c" c1),
      int_of_string (Printf.sprintf "0x%c" c2),
      int_of_string (Printf.sprintf "0x%c" c3)
    in
    let m = ref 676 in
    let color_code = ref "" in
    Array.iter (fun (color, code) ->
      let sqd = square_dist color rgb in
      if sqd < !m then begin
        color_code := code;
        m := sqd;
      end
    ) colors;
    Printf.printf "\027[%s;1m%c%c%c\027[00m" !color_code c1 c2 c3;
  done;
  for j = !k to pred n do
    let c = s.[j] in
    Printf.printf "\027[0;1m%c\027[00m" c;
  done

let r = Str.regexp "^\\([A-Fa-f0-9]+\\)\\([ \t]+.+\\)$"

let color_checksum () =
  try while true do
    let line = input_line stdin in
    if Str.string_match r line 0
    then begin
      let s1 = Str.matched_group 1 line in
      let s2 = Str.matched_group 2 line in
      print_color s1;
      print_endline s2;
    end
    else print_endline line
  done with End_of_file -> ()

let cat () =
  try while true do
    let line = input_line stdin in
    print_endline line
  done with End_of_file -> ()

let () =
  if Unix.isatty Unix.stdout
  then color_checksum ()
  else cat ()
