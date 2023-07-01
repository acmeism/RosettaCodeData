fun recLimit () =
  1 + recLimit ()
  handle _ => 0

val () = print (Int.toString (recLimit ()) ^ "\n")
