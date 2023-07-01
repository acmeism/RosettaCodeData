object StateNamePuzzle extends App {
  // Logic:
  def disjointPairs(pairs: Seq[Set[String]]) =
    for (a <- pairs; b <- pairs; if a.intersect(b).isEmpty) yield Set(a,b)

  def anagramPairs(words: Seq[String]) =
    (for (a <- words; b <- words; if a != b) yield Set(a, b)) // all pairs
    .groupBy(_.mkString.toLowerCase.replaceAll("[^a-z]", "").sorted) // grouped anagram pairs
    .values.map(disjointPairs).flatMap(_.distinct) // unique non-overlapping anagram pairs

  // Test:
  val states = List(
    "New Kory", "Wen Kory", "York New", "Kory New", "New Kory",
    "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
    "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
    "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine",
    "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
    "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
    "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
    "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
    "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia",
    "Washington", "West Virginia", "Wisconsin", "Wyoming"
  )

  println(anagramPairs(states).map(_.map(_ mkString " + ") mkString " = ") mkString "\n")
}
