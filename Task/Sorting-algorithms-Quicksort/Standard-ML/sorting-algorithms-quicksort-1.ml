fun quicksort [] = []
  | quicksort (x::xs) =
    let
        val (left, right) = List.partition (fn y => y<x) xs
    in
        quicksort left @ [x] @ quicksort right
    end
