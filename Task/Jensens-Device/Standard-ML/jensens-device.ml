val i = ref 42 (* initial value doesn't matter *)

fun sum' (i, lo, hi, term) = let
  val result = ref 0.0
in
  i := lo;
  while !i <= hi do (
    result := !result + term ();
    i := !i + 1
  );
  !result
end

val () =
  print (Real.toString (sum' (i, 1, 100, fn () => 1.0 / real (!i))) ^ "\n")
