fun quicksort [] = []
  | quicksort (x::xs) =
    let
        val (left, right) = List.partition (fn y => y<x) xs
    in
        quicksort left @ [x] @ quicksort right
    end

------------------------------------------------------------

Solution 2:

Without using List.partition

fun par_helper([], x, l, r) = (l, r) |
	par_helper(h::t, x, l, r) =
		if h <= x then
			par_helper(t, x, l @ [h], r)
		else
			par_helper(t, x, l, r @ [h]);

fun par(l, x) = par_helper(l, x, [], []);

fun quicksort [] = []
  | quicksort (h::t) =
    let
        val (left, right) = par(t, h)
    in
        quicksort left @ [h] @ quicksort right
    end;
