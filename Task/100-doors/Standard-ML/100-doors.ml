datatype Door = Closed | Opened

fun toggle Closed = Opened
  | toggle Opened = Closed

fun pass (steps, doors) = List.mapi (fn (k, door) => if (k+1) mod steps = 0 then toggle door else door) doors

(* [1..n] *)
fun runs n = List.tabulate (n, fn k => k+1)

fun run n =
	let
		val initialdoors = List.tabulate (n, fn _ => Closed)
		val runs = runs n
	in
		foldl pass initialdoors runs
	end

fun opened_doors n = List.mapPartiali (fn (k, Closed) => NONE | (k, Opened) => SOME (k+1)) (run n)
