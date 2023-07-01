def longestCommonSubstringsOptimizedPureFP(left: String, right: String): Option[Set[String]] =
  if (left.nonEmpty && right.nonEmpty) {
    val (shorter, longer) =
      if (left.length < right.length) (left, right)
      else (right, left)

    @scala.annotation.tailrec
    def recursive(
      indexLonger: Int = 0,
      indexShorter: Int = 0,
      currentLongestLength: Int = 0,
      lengthsPrior: List[Int] = List.fill(shorter.length)(0),
      lengths: List[Int] = Nil,
      accumulator: List[Int] = Nil
    ): (Int, List[Int]) =
      if (indexLonger < longer.length) {
        val length =
          if (longer(indexLonger) != shorter(indexShorter)) 0
          else lengthsPrior.head + 1
        val newCurrentLongestLength =
          if (length > currentLongestLength) length
          else currentLongestLength
        val newAccumulator =
          if ((length < currentLongestLength) || (length == 0)) accumulator
          else {
            val entry = indexShorter - length + 1
            if (length > currentLongestLength) List(entry)
            else entry :: accumulator
          }
        if (indexShorter < shorter.length - 1)
          recursive(
            indexLonger,
            indexShorter + 1,
            newCurrentLongestLength,
            lengthsPrior.tail,
            length :: lengths,
            newAccumulator
          )
        else
          recursive(
            indexLonger + 1,
            0,
            newCurrentLongestLength,
            0 :: lengths.reverse,
            Nil,
            newAccumulator
          )
      }
      else (currentLongestLength, accumulator)

    val (length, indexShorters) = recursive()
    if (indexShorters.nonEmpty)
      Some(
        indexShorters
          .map {
            indexShorter =>
              shorter.substring(indexShorter, indexShorter + length)
          }
          .toSet
      )
    else None
  }
  else None

println(longestCommonSubstringsOptimizedPureFP("thisisatest", "testing123testing"))
