(*
 * Head-Tail implementation of grouping
 *)
fun group'     ac      nil = [ac]
  | group'     nil (y::ys) = group' [y] ys
  | group' (x::ac) (y::ys) = if x=y then group' (y::x::ac) ys else (x::ac) :: group' [y] ys

fun group xs = group' nil xs

fun groupString str = String.concatWith ", " (map implode (group (explode str)))
