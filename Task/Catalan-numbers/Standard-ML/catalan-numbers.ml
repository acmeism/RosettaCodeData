(*
 * val catalan : int -> int
 * Returns the nth Catalan number.
 *)
fun catalan 0 = 1
|   catalan n = ((4 * n - 2) * catalan(n - 1)) div (n + 1);

(*
 * val print_catalans : int -> unit
 * Prints out Catalan numbers 0 through 15.
 *)
fun print_catalans(n) =
    if n > 15 then ()
    else (print (Int.toString(catalan n) ^ "\n"); print_catalans(n + 1)); print_catalans(0);
(*
 * 1
 * 1
 * 2
 * 5
 * 14
 * 42
 * 132
 * 429
 * 1430
 * 4862
 * 16796
 * 58786
 * 208012
 * 742900
 * 2674440
 * 9694845
 *)
