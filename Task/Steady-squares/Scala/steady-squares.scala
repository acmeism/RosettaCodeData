def steadySquares(cand: Seq[Int], modulo: Long, acc: Seq[Int]): Seq[Int] = {
  if (cand.isEmpty) return acc
  val num = cand.head
  val numl = num.toLong
  val modulo1 = if (modulo > numl) modulo else 10 * modulo
  val acc1 = if (numl * numl % modulo1 != numl) acc
             else acc :+ num
  steadySquares(cand.tail, modulo1, acc1)
}

val limit = 1_000_000
val candidates = Seq(0, 1) ++ (5 to limit by 10).flatMap(n => Seq(n, n + 1))
val list = steadySquares(candidates, 1, Seq())

@main def main = {
  val start = System.currentTimeMillis
  val max = list.last.toLong
  val Seq(maxLen, sqrLen) = Seq(max, max * max).map(_.toString.length)
  for (steadySquare <- list) {
    val stSqr = steadySquare.toLong
    val sqr = stSqr * stSqr
    println("%%%dd %%%dd".format(maxLen, sqrLen).format(stSqr, sqr))
  }
  val duration = System.currentTimeMillis - start
  println(s"time(ms): $duration")
}
