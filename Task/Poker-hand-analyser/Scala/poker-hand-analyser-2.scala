val testHands = List(
  "2H 2D 2S KS QD",
  "2H 5H 7D 8S 9D",
  "AH 2D 3S 4S 5S",
  "2H 3H 2D 3S 3D",
  "2H 7H 2D 3S 3D",
  "2H 7H 7D 7S 7C",
  "TH JH QH KH AH",
  "4H 4C KC 5D TC",
  "QC TC 7C 6C 4C",
  "QC TC 7C 7C TD",
  "2H 2D 2S KS joker",
  "2H 5H 7D 8S joker",
  "AH 2D 3S 4S joker",
  "2H 3H 2D 3S joker",
  "2H 7H 2D 3S joker",
  "2H 7H 7D joker joker",
  "TH JH QH joker joker",
  "4H 4C KC joker joker",
  "QC TC 7C joker joker",
  "QC TC 7H joker joker"
)

for (hand <- testHands) {
  println(s"$hand -> ${analyzeHand(parseHand(hand))}")
}
