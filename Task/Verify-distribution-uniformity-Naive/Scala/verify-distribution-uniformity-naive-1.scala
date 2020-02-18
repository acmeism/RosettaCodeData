object DistrubCheck1 extends App {

  private def distCheck(f: () => Int, nRepeats: Int, delta: Double): Unit = {
    val counts = scala.collection.mutable.Map[Int, Int]()

    for (_ <- 0 until nRepeats)
      counts.updateWith(f()) {
        case Some(count) => Some(count + 1)
        case None => Some(1)
      }

    val target: Double = nRepeats.toDouble / counts.size
    val deltaCount: Int = (delta / 100.0 * target).toInt
    counts.foreach {
      case (k, v) =>
        if (math.abs(target - v) >= deltaCount)
          println(f"distribution potentially skewed for $k%s: $v%d")
    }
    counts.toIndexedSeq.foreach(entry => println(f"${entry._1}%d ${entry._2}%d"))
  }

  distCheck(() => 1 + util.Random.nextInt(5), 1_000_000, 1)

}
