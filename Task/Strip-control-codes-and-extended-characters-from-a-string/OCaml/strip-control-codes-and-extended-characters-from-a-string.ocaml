let is_control_code c =
  c < '\032' || c = '\127'

let is_extended_char c =
  c > '\127'

let strip f str =
  let len = String.length str in
  let res = Bytes.create len in
  let rec aux i j =
    if i >= len
    then Bytes.sub_string res 0 j
    else if f str.[i]
    then aux (succ i) j
    else begin
      Bytes.set res j str.[i];
      aux (succ i) (succ j)
    end
  in
  aux 0 0

let () =
  Random.self_init ();
  let len = 32 in
  let s =
    String.init len (fun _ ->
      char_of_int (Random.int 256))
  in
  print_endline (strip is_control_code s);
  print_endline (strip (fun c -> is_control_code c || is_extended_char c) s)
