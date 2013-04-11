(* this function only recognizes integers in decimal format *)
fun isInteger s = case Int.scan StringCvt.DEC Substring.getc (Substring.full s) of
   SOME (_,subs) => Substring.isEmpty subs
 | NONE          => false

fun isReal s = case Real.scan Substring.getc (Substring.full s) of
   SOME (_,subs) => Substring.isEmpty subs
 | NONE          => false

fun isNumeric s = isInteger s orelse isReal s
