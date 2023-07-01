  def coincidients(s1: Seq[Char], s2: Seq[Char]): Int = (s1, s2).zipped.count(p => (p._1 == p._2))
  def freqMap(s1: List[Char]) = s1.groupBy(_.toChar).mapValues(_.size)
  def estimate(s1: List[Char]): Int = if (s1 == Nil) 0 else List(0, freqMap(s1).maxBy(_._2)._2 - (s1.size / 2)).max

  def bestShuffle(s: String): Pair[String, Int] = {
    if (s == "") return ("", 0) else {}
    val charList = s.toList
    val estim = estimate(charList)

    // purely functional polynomial solution
    def doStep(accu: List[Pair[Int, Int]], sourceFreqMap: Map[Int, Int], targetFreqMap: Map[Int, Int], stepsLeft: Int): List[Pair[Int, Int]] = {
      if (stepsLeft == 0) accu else {
        val srcChoices = sourceFreqMap.groupBy(_._2).minBy(_._1)._2
        val src = srcChoices.toList.apply(Random.nextInt(srcChoices.size))._1

        val tgtChoices = targetFreqMap.map(p => if (charList(p._1) != charList(src)) (p._1, p._2) else (p._1, Int.MaxValue / 2)).groupBy(_._2).minBy(_._1)._2
        val tgt = tgtChoices.toList.apply(Random.nextInt(tgtChoices.size))._1
        doStep((src, tgt) :: accu,
          sourceFreqMap.filterKeys(_ != src).map(p => if (charList(p._1) != charList(tgt)) (p._1, p._2 - 1) else (p._1, p._2)),
          targetFreqMap.filterKeys(_ != tgt).map(p => if (charList(p._1) != charList(src)) (p._1, p._2 - 1) else (p._1, p._2)),
          stepsLeft - 1)
      }
    }

    val leftFreqMap: Map[Int, Int] = charList.zipWithIndex.map(p => (p._2, p._1)).toMap.mapValues(x => freqMap(charList).mapValues(charList.size - _)(x))

    val substs = doStep(List(), leftFreqMap, leftFreqMap, charList.size)
    val res = substs.sortBy(_._1).map(p => charList(p._2))
    (res.mkString, coincidients(charList, res))

    // exponential solution (inefficient)
    //Random.shuffle(charList).permutations.find(coincidients(charList, _) <= estim)

  }
