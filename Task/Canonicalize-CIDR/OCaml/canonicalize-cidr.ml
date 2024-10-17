let mask = function
  | _, 0 -> 0l, 0
  | a, l -> Int32.(logand (shift_left minus_one (-l land 31)) a), l

let str_to_cidr s =
  let (<<+) b a = Int32.(add (shift_left b 8) a) in
  let recv d c b a l = d <<+ c <<+ b <<+ a, l in
  Scanf.sscanf s "%3lu.%3lu.%3lu.%3lu/%2u" recv

let cidr_to_str (a, l) =
  let addr n =
    let dgt = function
      | h :: t -> Int32.shift_right_logical h 8 :: Int32.logand h 255l :: t
      | l -> l
    in
    dgt [n] |> dgt |> dgt |> List.map Int32.to_string |> String.concat "."
  in
  Printf.sprintf "%s/%u" (addr a) l

let () =
  ["87.70.141.1/22"; "36.18.154.103/12"; "62.62.197.11/29"; "67.137.119.181/4"; "161.214.74.21/24"; "184.232.176.184/18"; "10.207.219.251/32"]
  |> List.iter (fun s -> str_to_cidr s |> mask |> cidr_to_str |> print_endline)
