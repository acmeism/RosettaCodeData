datatype param = A of string | B of real | C of int

fun args xs =
	let
	  (* Default values *)
	  val a = ref "hello world"
	  val b = ref 3.14
	  val c = ref 42
	in
	  map (fn (A x) => a := x | (B x) => b := x | (C x) => c := x) xs;
	  (!a, !b, !c)
	end
