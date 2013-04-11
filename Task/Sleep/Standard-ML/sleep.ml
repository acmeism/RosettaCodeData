(TextIO.print "input a number of seconds please: ";
let val seconds = valOf (Int.fromString (valOf (TextIO.inputLine TextIO.stdIn))) in
  TextIO.print "Sleeping...\n";
  OS.Process.sleep (Time.fromReal seconds);  (* it takes a Time.time data structure as arg,
                                               but in my implementation it seems to round down to the nearest second.
                                               I dunno why; it doesn't say anything about this in the documentation *)
  TextIO.print "Awake!\n"
end)
