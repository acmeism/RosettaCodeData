object VanDerCorput extends App {
    def compute(n: Int, base: Int = 2) =
        Iterator.from(0).
            scanLeft(1)((a, _) => a * base).
            map(b => (n - 1) / b -> b).
            takeWhile(_._1 != 0).
            foldLeft(0d)((a, b) => a + (b._1 % base).toDouble / b._2 / base)

    val n = scala.io.StdIn.readInt
    val b = scala.io.StdIn.readInt
    (1 to n).foreach(x => println(compute(x, b)))
}
