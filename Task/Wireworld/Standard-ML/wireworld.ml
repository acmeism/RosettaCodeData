(* Maximilian Wuttke 12.04.2016 *)

type world = char vector vector

fun getstate (w:world, (x, y)) = (Vector.sub (Vector.sub (w, y), x)) handle Subscript => #" "

fun conductor (w:world, (x, y)) =
	let
	  val s = [getstate (w, (x-1, y-1)) = #"H", getstate (w, (x-1, y)) = #"H", getstate (w, (x-1, y+1)) = #"H",
	           getstate (w, (x,   y-1)) = #"H",                                getstate (w, (x,   y+1)) = #"H",
	           getstate (w, (x+1, y-1)) = #"H", getstate (w, (x+1, y)) = #"H", getstate (w, (x+1, y+1)) = #"H"]
	  (* Count `true` in s *)
	  val count = List.length (List.filter (fn x => x=true) s)
	in
	  if count = 1 orelse count = 2 then #"H" else #"."
	end

fun translate (w:world, (x, y)) =
	case getstate (w, (x, y)) of
	   #" " => #" "
	 | #"H" => #"t"
	 | #"t" => #"."
	 | #"." => conductor (w, (x, y))
	 | s    => s

fun next_world (w : world) = Vector.mapi (fn (y, row) => Vector.mapi (fn (x, _) => translate (w, (x, y))) row) w


(* Test *)

(* makes a list of strings into a world *)
fun make_world (rows : string list) : world =
	Vector.fromList (map (fn (row : string) => Vector.fromList (explode row)) rows)


(* word_str reverses make_world *)
fun vec_str (r:char vector) = implode (List.tabulate (Vector.length r, fn x => Vector.sub (r, x)))
fun world_str (w:world)     = List.tabulate (Vector.length w, fn y => vec_str (Vector.sub (w, y)))
fun print_world (w:world)   = (map (fn row_str => print (row_str ^ "\n")) (world_str w); ())

val test = make_world [
	"tH.........",
	".   .      ",
	"   ...     ",
	".   .      ",
	"Ht.. ......"]
