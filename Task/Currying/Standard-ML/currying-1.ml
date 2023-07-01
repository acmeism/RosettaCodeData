fun addnums (x:int) y = x+y  (* declare a curried function *)

val add1 = addnums 1         (* bind the first argument to get another function *)
add1 42                      (* apply to actually compute a result, 43 *)
