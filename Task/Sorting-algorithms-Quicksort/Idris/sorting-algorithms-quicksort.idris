quicksort : Ord elem => List elem -> List elem
quicksort [] = []
quicksort (x :: xs) =
  let lesser = filter (< x) xs
      greater = filter(>= x) xs in
        (quicksort lesser) ++ [x] ++ (quicksort greater)
