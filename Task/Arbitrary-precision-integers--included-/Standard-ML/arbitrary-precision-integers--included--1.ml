let
  val answer = IntInf.pow (5, IntInf.toInt (IntInf.pow (4, IntInf.toInt (IntInf.pow (3, 2)))))
  val s = IntInf.toString answer
  val len = size s
in
  print ("has " ^ Int.toString len ^ " digits: " ^
         substring (s, 0, 20) ^ " ... " ^
         substring (s, len-20, 20) ^ "\n")
end;
