fun doSleep () =
  let
    val maybeline = TextIO.inputLine TextIO.stdIn
    val line = if isSome maybeline then valOf maybeline else raise Fail "Enter a number of seconds"
    val maybesecs = Real.fromString line
    val secs = if isSome maybesecs then valOf maybesecs else raise Fail "Bad number entered"
    val () = print "Sleeping...\n"
    val () = OS.Process.sleep (Time.fromReal secs)
    val () = print "Awake!\n"
  in
    ()
  end
