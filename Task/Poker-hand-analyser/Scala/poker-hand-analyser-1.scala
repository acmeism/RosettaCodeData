val faces = "23456789TJQKA"
val suits = "CHSD"
sealed trait Card
object Joker extends Card
case class RealCard(face: Int, suit: Char) extends Card
val allRealCards = for {
  face <- 0 until faces.size
  suit <- suits
} yield RealCard(face, suit)

def parseCard(str: String): Card = {
  if (str == "joker") {
    Joker
  } else {
    RealCard(faces.indexOf(str(0)), str(1))
  }
}

def parseHand(str: String): List[Card] = {
  str.split(" ").map(parseCard).toList
}

trait HandType {
  def name: String
  def check(hand: List[RealCard]): Boolean
}

case class And(x: HandType, y: HandType, name: String) extends HandType {
  def check(hand: List[RealCard]) = x.check(hand) && y.check(hand)
}

object Straight extends HandType {
  val name = "straight"
  def check(hand: List[RealCard]): Boolean = {
    val faces = hand.map(_.face).toSet
    faces.size == 5 && (faces.min == faces.max - 4 || faces == Set(0, 1, 2, 3, 12))
  }
}

object Flush extends HandType {
  val name = "flush"
  def check(hand: List[RealCard]): Boolean = {
    hand.map(_.suit).toSet.size == 1
  }
}

case class NOfAKind(n: Int, name: String = "", nOccur: Int = 1) extends HandType {
  def check(hand: List[RealCard]): Boolean = {
    hand.groupBy(_.face).values.count(_.size == n) >= nOccur
  }
}

val allHandTypes = List(
  NOfAKind(5, "five-of-a-kind"),
  And(Straight, Flush, "straight-flush"),
  NOfAKind(4, "four-of-a-kind"),
  And(NOfAKind(3), NOfAKind(2), "full-house"),
  Flush,
  Straight,
  NOfAKind(3, "three-of-a-kind"),
  NOfAKind(2, "two-pair", 2),
  NOfAKind(2, "one-pair")
)

def possibleRealHands(hand: List[Card]): List[List[RealCard]] = {
  val realCards = hand.collect { case r: RealCard => r }
  val nJokers = hand.count(_ == Joker)
  allRealCards.toList.combinations(nJokers).map(_ ++ realCards).toList
}

def analyzeHand(hand: List[Card]): String = {
  val possibleHands = possibleRealHands(hand)
  allHandTypes.find(t => possibleHands.exists(t.check)).map(_.name).getOrElse("high-card")
}
