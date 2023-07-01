fun columns l =
  case List.filter (not o null) l of
    [] => []
  | l => map hd l :: columns (map tl l)

fun replicate (n, x) = List.tabulate (n, fn _ => x)

fun bead_sort l =
  map length (columns (columns (map (fn e => replicate (e, 1)) l)))
