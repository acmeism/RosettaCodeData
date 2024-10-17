let egypt_div x y =
  let rec table p d lst =
    if d > x
    then lst
    else table (p + p) (d + d) ((p, d) :: lst)
  in
  let consider (q, a) (p, d) =
    if a + d > x
    then q, a
    else q + p, a + d
  in
  List.fold_left consider (0, 0) (table 1 y [])
