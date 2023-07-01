object NoConnection extends App {

  private def links = Seq(
    Seq(2, 3, 4), // A to C,D,E
    Seq(3, 4, 5), // B to D,E,F
    Seq(2, 4), // D to C, E
    Seq(5), // E to F
    Seq(2, 3, 4), // G to C,D,E
    Seq(3, 4, 5)) // H to D,E,F

  private def genRandom: LazyList[Seq[Int]] = util.Random.shuffle((1 to 8).toList) #:: genRandom

  private def notSolved(links: Seq[Seq[Int]], pegs: Seq[Int]): Boolean =
    links.indices.forall(
      i => !links(i).forall(peg => math.abs(pegs(i) - peg) == 1))

  private def printResult(pegs: Seq[Int]) = {
    println(f"${pegs(0)}%3d${pegs(1)}%2d")
    println(f"${pegs(2)}%1d${pegs(3)}%2d${pegs(4)}%2d${pegs(5)}%2d")
    println(f"${pegs(6)}%3d${pegs(7)}%2d")
  }

  printResult(genRandom.dropWhile(!notSolved(links, _)).head)
}
