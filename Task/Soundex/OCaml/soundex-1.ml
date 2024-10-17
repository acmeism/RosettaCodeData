let c2d = function
  | 'B' | 'F' | 'P' | 'V' -> "1"
  | 'C' | 'G' | 'J' | 'K' | 'Q' | 'S' | 'X' | 'Z' -> "2"
  | 'D' | 'T' -> "3"
  | 'L' -> "4"
  | 'M' | 'N' -> "5"
  | 'R' -> "6"
  | _ -> ""

let rec dbl acc = function
  | [] -> (List.rev acc)
  | [c] -> List.rev(c::acc)
  | c1::(c2::_ as tl) ->
      if c1 = c2
      then dbl acc tl
      else dbl (c1::acc) tl

let pad s =
  match String.length s with
  | 0 -> s ^ "000"
  | 1 -> s ^ "00"
  | 2 -> s ^ "0"
  | 3 -> s
  | _ -> String.sub s 0 3

let soundex_aux rem =
  pad(String.concat "" (dbl [] (List.map c2d rem)))

let soundex s =
  let s = String.uppercase s in
  let cl = ref [] in
  String.iter (fun c -> cl := c :: !cl) s;
  match dbl [] (List.rev !cl) with
  | c::rem -> (String.make 1 c) ^ (soundex_aux rem)
  | [] -> invalid_arg "soundex"
