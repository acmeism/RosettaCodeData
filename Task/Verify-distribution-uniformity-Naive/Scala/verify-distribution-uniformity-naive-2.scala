object DistrubCheck2 extends App {
  private def distCheck(f: () => Int, nRepeats: Int, delta: Double): Unit = {
    val counts: Map[Int, Int] =
      (0 until nRepeats).map(_ => f()).groupBy(identity).map { case (k, v) => (k, v.size) }
    val target = nRepeats / counts.size.toDouble

    counts.withFilter { case (_, v) => math.abs(target - v) >= (delta / 100.0 * target) }
      .foreach { case (k, v) => println(f"distribution potentially skewed for $k%s: $v%d") }

    counts.toIndexedSeq.foreach(entry => println(f"${entry._1}%d ${entry._2}%d"))
  }

  distCheck(() => 1 + util.Random.nextInt(5), 1_000_000, 1)

}
