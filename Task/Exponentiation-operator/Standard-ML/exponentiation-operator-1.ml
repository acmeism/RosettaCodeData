fun expt_int (a, b) = let
  fun aux (x, i) =
    if i = b then x
    else aux (x * a, i + 1)
in
  aux (1, 0)
end

fun expt_real (a, b) = let
  fun aux (x, i) =
    if i = b then x
    else aux (x * a, i + 1)
in
  aux (1.0, 0)
end

val op ** = expt_int
infix 6 **
val op *** = expt_real
infix 6 ***
