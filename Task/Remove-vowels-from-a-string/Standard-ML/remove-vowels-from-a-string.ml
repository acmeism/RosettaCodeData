fun isVowel c =
  CharVector.exists (fn v => c = v) "AaEeIiOoUu"

val removeVowels =
  String.translate (fn c => if isVowel c then "" else str c)

val str = "LOREM IPSUM dolor sit amet\n"
val () = print str
val () = print (removeVowels str)
