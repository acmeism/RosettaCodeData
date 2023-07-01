// Split a (character) string into comma (plus a blank) delimited strings
// based on a change of character (left to right).
// See https://rosettacode.org/wiki/Split_a_character_string_based_on_change_of_character#Scala

def runLengthSplit(s: String): String = /// Add a guard letter
  (s + 'X').sliding(2).map(pair => pair.head + (if (pair.head != pair.last) ", " else "")).mkString("")

println(runLengthSplit("""gHHH5YY++///\"""))
