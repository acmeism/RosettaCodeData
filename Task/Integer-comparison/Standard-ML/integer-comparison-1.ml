fun compare_integers(a, b) =
  if a < b then print "A is less than B\n"
  if a > b then print "A is greater than B\n"
  if a = b then print "A equals B\n"

 fun test () =
  let
    open TextIO
    val SOME a = Int.fromString (input stdIn)
    val SOME b = Int.fromString (input stdIn)
  in
    compare_integers (a, b)
  end
    handle Bind => print "Invalid number entered!\n"
