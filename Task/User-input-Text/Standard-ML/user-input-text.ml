print "Enter a string: ";
let val str = valOf (TextIO.inputLine TextIO.stdIn) in (* note: this keeps the trailing newline *)
  print "Enter an integer: ";
  let val num = valOf (TextIO.scanStream (Int.scan StringCvt.DEC) TextIO.stdIn) in
    print (str ^ Int.toString num ^ "\n")
  end
end
