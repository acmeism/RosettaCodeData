datatype Door = Closed | Opened

fun toggle Closed = Opened
  | toggle Opened = Closed

fun pass (step, doors) = List.map (fn (index, door) => if (index mod step) = 0
						       then (index, toggle door)
						       else (index, door))
				  doors

(* [1..n] *)
fun runs n = List.tabulate (n, fn k => k+1)

fun run n =
    let
	val initialdoors = List.tabulate (n, fn i => (i+1, Closed))
	val counter = runs n
    in
	foldl pass initialdoors counter
    end

fun opened_doors n = List.mapPartial (fn (index, Closed) => NONE
				       | (index, Opened) => SOME (index))
				     (run n)
