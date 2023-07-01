let rec shift n l = if n <= 0 then l else shift (n-1) (l @ [0.0])
let rec pad n l = if n <= 0 then l else pad (n-1) (0.0 :: l)
let rec norm = function | 0.0 :: tl -> norm tl | x -> x
let deg l = List.length (norm l) - 1

let zip op p q =
  let d = (List.length p) - (List.length q) in
  List.map2 op (pad (-d) p) (pad d q)

let polydiv f g =
  let rec aux f s q =
    let ddif = (deg f) - (deg s) in
    if ddif < 0 then (q, f) else
      let k = (List.head f) / (List.head s) in
      let ks = List.map ((*) k) (shift ddif s) in
      let q' = zip (+) q (shift ddif [k])
      let f' = norm (List.tail (zip (-) f ks)) in
      aux f' s q' in
  aux (norm f) (norm g) []

let str_poly l =
  let term v p = match (v, p) with
    | (  _, 0) -> string v
    | (1.0, 1) -> "x"
    | (  _, 1) -> (string v) + "*x"
    | (1.0, _) -> "x^" + (string p)
    | _ -> (string v) + "*x^" + (string p) in
  let rec terms = function
    | [] -> []
    | h :: t ->
       if h = 0.0 then (terms t) else (term h (List.length t)) :: (terms t) in
  String.concat " + " (terms l)

let _ =
  let f,g = [1.0; -4.0; 6.0; 5.0; 3.0], [1.0; 2.0; 1.0] in
  let q, r = polydiv f g in
  Printf.printf
    " (%s) div (%s)\ngives\nquotient:\t(%s)\nremainder:\t(%s)\n"
    (str_poly f) (str_poly g) (str_poly q) (str_poly r)
