let sort_table ?(ordering = compare) ?(column = 0) ?(reverse = false) table =
  let cmp x y = ordering (List.nth x column) (List.nth y column) * (if reverse then -1 else 1) in
    List.sort cmp table
