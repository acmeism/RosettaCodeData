fun bitwise_words (a, b) = (
  print ("a and b: " ^ Word.fmt StringCvt.DEC (Word.andb (a, b)) ^ "\n");
  print ("a or b: "  ^ Word.fmt StringCvt.DEC (Word.orb  (a, b)) ^ "\n");
  print ("a xor b: " ^ Word.fmt StringCvt.DEC (Word.xorb (a, b)) ^ "\n");
  print ("not a: "   ^ Word.fmt StringCvt.DEC (Word.notb a     ) ^ "\n");
  print ("a lsl b: " ^ Word.fmt StringCvt.DEC (Word.<< (a, b)  ) ^ "\n");  (* left shift *)
  print ("a asr b: " ^ Word.fmt StringCvt.DEC (Word.~>> (a, b) ) ^ "\n");  (* arithmetic right shift *)
  print ("a asr b: " ^ Word.fmt StringCvt.DEC (Word.>> (a, b)  ) ^ "\n")   (* logical right shift *)
)
