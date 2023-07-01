import scala.annotation.tailrec

object Chess960 extends App {

  private val pieces = List('♖', '♗', '♘', '♕', '♔', '♘', '♗', '♖')

  @tailrec
  private def generateFirstRank(pieces: List[Char]): List[Char] = {
    def check(rank: String) =
      rank.matches(".*♖.*♔.*♖.*") && rank.matches(".*♗(..|....|......|)♗.*")

    val p = scala.util.Random.shuffle(pieces)
    if (check(p.toString.replaceAll("[^\\p{Upper}]", "")))
      generateFirstRank(pieces)
    else p
  }

  loop(10)

  @tailrec
  private def loop(n: Int): Unit = {
    println(generateFirstRank(pieces))
    if (n <= 0) () else loop(n - 1)
  }
}
