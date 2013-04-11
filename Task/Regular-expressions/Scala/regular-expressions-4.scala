val Some(bottles) = Bottles4 findPrefixOf "99 bottles of beer" // throws an exception if the matching fails; full string must match
for {
  line <- """|99 bottles of beer on the wall
             |99 bottles of beer
             |Take one down, pass it around
             |98 bottles of beer on the wall""".stripMargin.lines
} line match {
  case Bottles1(bottles) => println("There are still "+bottles+" bottles.") // full string must match, so this will match only once
  case _ =>
}
for {
  matched <- "(\\w+)".r findAllIn "99 bottles of beer" matchData // matchData converts to an Iterator of Match
} println("Matched from "+matched.start+" to "+matched.end)
