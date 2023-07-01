fun repeat (_, 0) = ()
  | repeat (f, n) = (f (); repeat (f, n - 1))

fun testProcedure () =
  print "test\n"

val () = repeat (testProcedure, 5)
