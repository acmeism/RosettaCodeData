fun flatten (L  x) = [x]
  | flatten (N xs) = List.concat (map flatten xs)
