val () = let
  val a = valOf (Int.fromString (valOf (TextIO.inputLine TextIO.stdIn)))
  val b = valOf (Int.fromString (valOf (TextIO.inputLine TextIO.stdIn)))
in
  print ("a + b = "   ^ Int.toString (a + b)   ^ "\n");
  print ("a - b = "   ^ Int.toString (a - b)   ^ "\n");
  print ("a * b = "   ^ Int.toString (a * b)   ^ "\n");
  print ("a div b = " ^ Int.toString (a div b) ^ "\n");         (* truncates towards negative infinity *)
  print ("a mod b = " ^ Int.toString (a mod b) ^ "\n");         (* same sign as second operand *)
  print ("a quot b = " ^ Int.toString (Int.quot (a, b)) ^ "\n");(* truncates towards 0 *)
  print ("a rem b = " ^ Int.toString (Int.rem (a, b)) ^ "\n");  (* same sign as first operand *)
  print ("~a = "      ^ Int.toString (~a)      ^ "\n")          (* unary negation, unusual notation compared to other languages *)
end
