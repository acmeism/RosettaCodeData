object IndexFiniteList extends App {
  val (defBase, s) = (10, Seq(1, 2, 3, 10, 100, 987654321))

  def rank(x: Seq[Int], base: Int = defBase) =
    BigInt(x.map(Integer.toString(_, base)).mkString(base.toHexString), base + 1)

  def unrank(n: BigInt, base: Int = defBase): List[BigInt] =
    n.toString(base + 1).split((base).toHexString).map(BigInt(_)).toList

  val ranked = rank(s)

  println(s.mkString("[", ", ", "]"))
  println(ranked)
  println(unrank(ranked).mkString("[", ", ", "]"))

}
