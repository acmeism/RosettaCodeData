fun max_of_ints [] = raise Empty
  | max_of_ints (x::xs) = foldl Int.max x xs
