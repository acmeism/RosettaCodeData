object SubsetSum extends App {
  private val LIMIT = 5
  private val n = items.length
  private val indices = new Array[Int](n)
  private var count = 0

  private def items = Seq(
    Item("alliance", -624),
    Item("archbishop", -915),
    Item("balm", 397),
    Item("bonnet", 452),
    Item("brute", 870),
    Item("centipede", -658),
    Item("cobol", 362),
    Item("covariate", 590),
    Item("departure", 952),
    Item("deploy", 44),
    Item("diophantine", 645),
    Item("efferent", 54),
    Item("elysee", -326),
    Item("eradicate", 376),
    Item("escritoire", 856),
    Item("exorcism", -983),
    Item("fiat", 170),
    Item("filmy", -874),
    Item("flatworm", 503),
    Item("gestapo", 915),
    Item("infra", -847),
    Item("isis", -982),
    Item("lindholm", 999),
    Item("markham", 475),
    Item("mincemeat", -880),
    Item("moresby", 756),
    Item("mycenae", 183),
    Item("plugging", -266),
    Item("smokescreen", 423),
    Item("speakeasy", -745),
    Item("vein", 813)
  )

  private def zeroSum(i: Int, w: Int): Unit = {
    if (count < LIMIT) {
      if (i != 0 && w == 0) {
        for (j <- 0 until i) print(f"${items(indices(j))}%s ")
        println
        count += 1
      } else
        for (j <- (if (i != 0) indices(i - 1) + 1 else 0) until n) {
          indices(i) = j
          zeroSum(i + 1, w + items(j).weight)
        }
    }
  }

  // Not optimized
  private case class Item(word: String, weight: Int) {
    override def toString: String = f"($word%s, $weight%d)"
  }

  println(f"The weights of the following $LIMIT%d subsets add up to zero:")
  zeroSum(0, 0)

}
