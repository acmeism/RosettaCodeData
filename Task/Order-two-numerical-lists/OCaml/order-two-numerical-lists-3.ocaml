let rec ordered_lists = function
  | x1::tl1, x2::tl2 ->
      (match compare x1 x2 with
      | 0 -> ordered_lists (tl1, tl2)
      | 1 -> false
      | _ -> true)
  | [], _ -> true
  | _ -> false
