let rec shift n l = if n <= 0 then l else shift (pred n) (l @ [0.0])
let rec pad n l = if n <= 0 then l else pad (pred n) (0.0 :: l)
let rec norm = function | 0.0 :: tl -> norm tl | x -> x
let deg l = List.length (norm l) - 1

let zip op p q =
  let d = (List.length p) - (List.length q) in
  List.map2 op (pad (-d) p) (pad d q)
