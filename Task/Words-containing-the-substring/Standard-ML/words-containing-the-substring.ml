val hasThe = String.isSubstring "the"

fun isThe12 s = size s > 11 andalso hasThe s

val () = print
  ((String.concatWith " "
    o List.filter isThe12
    o String.tokens Char.isSpace
    o TextIO.inputAll) TextIO.stdIn ^ "\n")
