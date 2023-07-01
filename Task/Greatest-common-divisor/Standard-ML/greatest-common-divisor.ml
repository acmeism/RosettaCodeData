(* Euclid’s algorithm. *)

fun gcd (u, v) =
    let
        fun loop (u, v) =
            if v = 0 then
                u
            else
                loop (v, u mod v)
    in
        loop (abs u, abs v)
    end

(* Using the Rosetta Code example for assertions in Standard ML. *)
fun assert cond =
    if cond then () else raise Fail "assert"

val () = assert (gcd (0, 0) = 0)
val () = assert (gcd (0, 10) = 10)
val () = assert (gcd (~10, 0) = 10)
val () = assert (gcd (9, 6) = 3)
val () = assert (gcd (~6, ~9) = 3)
val () = assert (gcd (40902, 24140) = 34)
val () = assert (gcd (40902, ~24140) = 34)
val () = assert (gcd (~40902, 24140) = 34)
val () = assert (gcd (~40902, ~24140) = 34)
val () = assert (gcd (24140, 40902) = 34)
val () = assert (gcd (~24140, 40902) = 34)
val () = assert (gcd (24140, ~40902) = 34)
val () = assert (gcd (~24140, ~40902) = 34)
