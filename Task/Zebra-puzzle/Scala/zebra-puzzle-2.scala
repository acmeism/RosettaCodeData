import scala.util.Try

object Einstein extends App {

  // The strategy here is to mount a brute-force attack on the solution space, pruning very aggressively.
  // The scala standard `permutations` method is extremely helpful here. It turns out that by pruning
  // quickly and smartly we can solve this very quickly (45ms on my machine) compared to days or weeks
  // required to fully enumerate the solution space.

  // We set up a for comprehension with an enumerator for each of the 5 variables, with if clauses to
  // prune. The hard part is the pruning logic, which is basically just translating the rules to code
  // and the data model. The data model is basically Seq[Seq[String]]

  // Rules are encoded as for comprehension filters. There is a natural cascade of rules from
  // depending on more or less criteria. The rules about smokes are the most complex and depend
  // on the most other factors

  // 4. The green house is just to the left of the white one.
  def colorRules(colors: Seq[String]) = Try(colors(colors.indexOf("White") - 1) == "Green").getOrElse(false)

  // 1. The Englishman lives in the red house.
  // 9. The Norwegian lives in the first house.
  // 14. The Norwegian lives next to the blue house.
  def natRules(colors: Seq[String], nats: Seq[String]) =
    nats.head == "Norwegian" && colors(nats.indexOf("Brit")) == "Red" &&
      (Try(colors(nats.indexOf("Norwegian") - 1) == "Blue").getOrElse(false) ||
        Try(colors(nats.indexOf("Norwegian") + 1) == "Blue").getOrElse(false))

  // 3. The Dane drinks tea.
  // 5. The owner of the green house drinks coffee.
  // 8. The man in the center house drinks milk.
  def drinkRules(colors: Seq[String], nats: Seq[String], drinks: Seq[String]) =
    drinks(nats.indexOf("Dane")) == "Tea" &&
      drinks(colors.indexOf("Green")) == "Coffee" &&
      drinks(2) == "Milk"

  // 2. The Swede keeps dogs.
  def petRules(nats: Seq[String], pets: Seq[String]) = pets(nats.indexOf("Swede")) == "Dogs"

  // 6. The Pall Mall smoker keeps birds.
  // 7. The owner of the yellow house smokes Dunhills.
  // 10. The Blend smoker has a neighbor who keeps cats.
  // 11. The man who smokes Blue Masters drinks bier.
  // 12. The man who keeps horses lives next to the Dunhill smoker.
  // 13. The German smokes Prince.
  // 15. The Blend smoker has a neighbor who drinks water.
  def smokeRules(colors: Seq[String], nats: Seq[String], drinks: Seq[String], pets: Seq[String], smokes: Seq[String]) =
    pets(smokes.indexOf("Pall Mall")) == "Birds" &&
      smokes(colors.indexOf("Yellow")) == "Dunhill" &&
      (Try(pets(smokes.indexOf("Blend") - 1) == "Cats").getOrElse(false) ||
        Try(pets(smokes.indexOf("Blend") + 1) == "Cats").getOrElse(false)) &&
      drinks(smokes.indexOf("BlueMaster")) == "Beer" &&
      (Try(smokes(pets.indexOf("Horses") - 1) == "Dunhill").getOrElse(false) ||
        Try(pets(pets.indexOf("Horses") + 1) == "Dunhill").getOrElse(false)) &&
      smokes(nats.indexOf("German")) == "Prince" &&
      (Try(drinks(smokes.indexOf("Blend") - 1) == "Water").getOrElse(false) ||
        Try(drinks(smokes.indexOf("Blend") + 1) == "Water").getOrElse(false))

  // once the rules are created it, the actual solution is simple: iterate brute force, pruning early.
  val solutions = for {
    colors <- Seq("Red", "Blue", "White", "Green", "Yellow").permutations if colorRules(colors)
    nats <- Seq("Brit", "Swede", "Dane", "Norwegian", "German").permutations if natRules(colors, nats)
    drinks <- Seq("Tea", "Coffee", "Milk", "Beer", "Water").permutations if drinkRules(colors, nats, drinks)
    pets <- Seq("Dogs", "Birds", "Cats", "Horses", "Fish").permutations if petRules(nats, pets)
    smokes <- Seq("BlueMaster", "Blend", "Pall Mall", "Dunhill", "Prince").permutations if smokeRules(colors, nats, drinks, pets, smokes)
  } yield Seq(colors, nats, drinks, pets, smokes)

  // There *should* be just one solution...
  solutions.foreach { solution =>
    // so we can pretty-print, find out the maximum string length of all cells
    val maxLen = solution.flatten.map(_.length).max

    def pretty(str: String): String = str + (" " * (maxLen - str.length + 1))

    // a labels column
    val labels = ("" +: Seq("Color", "Nation", "Drink", "Pet", "Smoke").map(_ + ":")).toIterator

    // print each row including a column header
    ((1 to 5).map(n => s"House $n") +: solution).map(_.map(pretty)).map(x => (pretty(labels.next) +: x).mkString(" ")).foreach(println)

    println()
    println(s"The ${solution(1)(solution(3).indexOf("Fish"))} owns the Fish")
  }

}
