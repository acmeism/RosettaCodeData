(* Languages with pattern matching ALREADY HAVE THIS! *)

fun myfunc (pred1, pred2) =
  case (pred1, pred2) of
    (true, true) => print ("(true, true)\n")
  | (true, false) => print ("(true, false)\n")
  | (false, true) => print ("(false, true)\n")
  | (false, false) => print ("(false, false)\n");

myfunc (true, true);
myfunc (true, false);
myfunc (false, true);
myfunc (false, false);
