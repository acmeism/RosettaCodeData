let histogram_median (h : histogram) =

  let from = 0 and to_ = 255 in
  let left = h.(from) and right = h.(to_) in

  let rec aux from to_ left right =
    if from = to_
    then (from)
    else
      if left < right
      then aux (succ from) to_ (left + h.(from)) right
      else aux from (pred to_) left (right + h.(to_))
  in
  aux from to_ left right
;;
