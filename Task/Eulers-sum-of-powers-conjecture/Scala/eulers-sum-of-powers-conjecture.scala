import scala.collection.Searching.{Found, search}

object EulerSopConjecture extends App {

  val (maxNumber, fifth) = (250, (1 to 250).map { i => math.pow(i, 5).toLong })

  def binSearch(fact: Int*) = fifth.search(fact.map(f => fifth(f)).sum)

  def sop = (0 until maxNumber)
    .flatMap(a => (a until maxNumber)
      .flatMap(b => (b until maxNumber)
        .flatMap(c => (c until maxNumber)
          .map { case x$1@d => (binSearch(a, b, c, d), x$1) }
          .withFilter { case (f, _) => f.isInstanceOf[Found] }
          .map { case (f, d) => (a + 1, b + 1, c + 1, d + 1, f.insertionPoint + 1) }))).take(1)
    .map { case (a, b, c, d, f) => s"$a⁵ + $b⁵ + $c⁵ + $d⁵ = $f⁵" }

  println(sop)

}
