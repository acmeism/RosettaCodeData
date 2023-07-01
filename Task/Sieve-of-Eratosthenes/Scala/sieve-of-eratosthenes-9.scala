  def SoEInc: Iterator[Int] = {
    val nextComposites = scala.collection.mutable.HashMap[Int, Int]()
    def oddPrimes: Iterator[Int] = {
      val basePrimes = SoEInc
      basePrimes.next()
      basePrimes.next() // skip the two and three prime factors
      @tailrec def makePrime(state: (Int, Int, Int)): (Int, Int, Int) = {
        val (candidate, nextBasePrime, nextSquare) = state
        if (candidate >= nextSquare) {
          val adv = nextBasePrime << 1
          nextComposites += ((nextSquare + adv) -> adv)
          val np = basePrimes.next()
          makePrime((candidate + 2, np, np * np))
        } else if (nextComposites.contains(candidate)) {
          val adv = nextComposites(candidate)
          nextComposites -= (candidate) += (Iterator.iterate(candidate + adv)(_ + adv)
            .dropWhile(nextComposites.contains(_)).next() -> adv)
          makePrime((candidate + 2, nextBasePrime, nextSquare))
        } else (candidate, nextBasePrime, nextSquare)
      }
      Iterator.iterate((5, 3, 9)) { case (c, p, q) => makePrime((c + 2, p, q)) }
        .map { case (p, _, _) => p }
    }
    List(2, 3).toIterator ++ oddPrimes
  }
