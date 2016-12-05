/* Note to the rules:
 *
 * It can further concluded that:
 * 5a: The green house cannot be at the h1 position
 * 5b: The white house cannot be at the h5 position
 *
 * 16: This rule is redundant.
 */

object Einstein extends App {
  class House(val nationality: String, val color: String, val beverage: String, val animal: String, val brand: String) {
    override def toString = { f"$nationality%10s, ${color + ", "}%-8s$beverage,\t$animal,\t$brand." }

    def totalUnEqual(home2: House) =
      this.animal != home2.animal &&
        this.beverage != home2.beverage &&
        this.brand != home2.brand &&
        this.color != home2.color &&
        this.nationality != home2.nationality

    //** Checks if the this green house is next to the other white house*/
    def checkAdjacentWhite(home2: House) = (this.color == "Green") == (home2.color == "White") // #5
  }

  val possibleMembers = for { // pair clues results in 78 members
    nationality <- List("Norweigan", "German", "Dane", "Englishman", "Swede")
    color <- List("Red", "Green", "Yellow", "White", "Blue")
    beverage <- List("Milk", "Coffee", "Tea", "Beer", "Water")
    animal <- List("Dog", "Horse", "Birds", "Cats", "Zebra")
    brand <- List("Blend", "Pall Mall", "Prince", "Blue Master", "Dunhill")
    if (color == "Red") == (nationality == "Englishman") // #2
    if (nationality == "Swede") == (animal == "Dog") // #3
    if (nationality == "Dane") == (beverage == "Tea") // #4
    if (color == "Green") == (beverage == "Coffee") // #6
    if (brand == "Pall Mall") == (animal == "Birds") // #7
    if (brand == "Dunhill") == (color == "Yellow") // #8
    if (brand == "Blue Master") == (beverage == "Beer") // #13
    if (brand == "Prince") == (nationality == "German") // #14
  } yield new House(nationality, color, beverage, animal, brand)

  def matchMiddleBrandAnimal(home1: House, home2: House, home3: House, brand: String, animal: String) =
    (home1.animal == animal || home2.brand != brand || home3.animal == animal) &&
      (home1.brand == brand || home2.animal != animal || home3.brand == brand)

  def matchCornerBrandAnimal(corner: House, inner: House, animal: String, brand: String) =
    (corner.brand != brand || inner.animal == animal) && (corner.animal == animal || inner.brand != brand)

  def housesLeftOver(pickedHouses: House*): List[House] = {
    possibleMembers.filter(house => pickedHouses.forall(_.totalUnEqual(house)))
  }

  val members = for { // Neighborhood clues
    h1 <- housesLeftOver().filter(p => (p.nationality == "Norweigan" /* #10 */ ) && (p.color != "Green") /* #5a */ ) // 28
    h3 <- housesLeftOver(h1).filter(p => p.beverage == "Milk") // #9 // 24
    h2 <- housesLeftOver(h1, h3).filter(_.color == "Blue") // #15
    if matchMiddleBrandAnimal(h1, h2, h3, "Blend", "Cats") // #11
    if matchCornerBrandAnimal(h1, h2, "Horse", "Dunhill") // #12
    h4 <- housesLeftOver(h1, h2, h3).filter(_.checkAdjacentWhite(h3) /* #5 */ )
    h5 <- housesLeftOver(h1, h2, h3, h4)

    //  Redundant tests
    if h2.checkAdjacentWhite(h1)
    if h3.checkAdjacentWhite(h2)
    if matchCornerBrandAnimal(h5, h4, "Horse", "Dunhill")
    if matchMiddleBrandAnimal(h2, h3, h4, "Blend", "Cats")
    if matchMiddleBrandAnimal(h3, h4, h5, "Blend", "Cats")
  } yield Seq(h1, h2, h3, h4, h5)

  // Main program
  val beest = "Zebra"
  members.flatMap(p => p.filter(p => p.animal == beest)).
    foreach(s => println(s"The ${s.nationality} is the owner of the ${beest.toLowerCase}."))

  println(s"The ${members.size} solution(s) are:")
  members.foreach(solution => solution.zipWithIndex.foreach(h => println("House " + (h._2 + 1) + " " + h._1)))
}
