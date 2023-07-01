fun bitwise_ints (a, b) = (
  print ("a and b: " ^ IntInf.toString (IntInf.andb (IntInf.fromInt a, IntInf.fromInt b)) ^ "\n");
  print ("a or b: "  ^ IntInf.toString (IntInf.orb  (IntInf.fromInt a, IntInf.fromInt b)) ^ "\n");
  print ("a xor b: " ^ IntInf.toString (IntInf.xorb (IntInf.fromInt a, IntInf.fromInt b)) ^ "\n");
  print ("not a: "   ^ IntInf.toString (IntInf.notb (IntInf.fromInt a                  )) ^ "\n");
  print ("a lsl b: " ^ IntInf.toString (IntInf.<<   (IntInf.fromInt a, Word.fromInt b  )) ^ "\n");  (* left shift *)
  print ("a asr b: " ^ IntInf.toString (IntInf.~>>  (IntInf.fromInt a, Word.fromInt b  )) ^ "\n")   (* arithmetic right shift *)
)
