fun test1 rand =
  (print (" " ^ Int.toString rand); rand)

fun test2 (rand, state) =
  (print (" " ^ Int.toString rand); state)

fun doTimes (_, 0, state) = ()
  | doTimes (f, n, state) = doTimes (f, n - 1, f state)

val () = print "BSD:\n"
val () = doTimes (test1 o bsdLcg, 7, 0)
val () = print "\nMSC:\n"
val () = doTimes (test2 o mscLcg, 7, 0w0)
val () = print "\n"
