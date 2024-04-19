fun bubble_select [] = []
  | bubble_select [a] = [a]
  | bubble_select (a::b::xs) =
    if b < a then b::(bubble_select(a::xs)) else a::(bubble_select(b::xs))

fun bubblesort [] = []
  | bubblesort (x::xs) =bubble_select (x::(bubblesort xs))
