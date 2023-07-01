def longestCommonSubstringsOptimizedReferentiallyTransparentFP(left: String, right: String): Option[Set[String]] =
  if (left.nonEmpty && right.nonEmpty) {
    val (shorter, longer) =
      if (left.length < right.length) (left, right)
      else (right, left)
    val lengths: Array[Int] = new Array(shorter.length) //mutable

    @scala.annotation.tailrec
    def recursive(
      indexLonger: Int = 0,
      indexShorter: Int = 0,
      currentLongestLength: Int = 0,
      lastIterationLength: Int = 0,
      accumulator: List[Int] = Nil
    ): (Int, List[Int]) =
      if (indexLonger < longer.length) {
        val length =
          if (longer(indexLonger) != shorter(indexShorter)) 0
          else
            if (indexShorter == 0) 1
            else lastIterationLength + 1
        val newLastIterationLength = lengths(indexShorter)
        lengths(indexShorter) = length //mutation
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
            newLastIterationLength,
            newAccumulator
          )
        else
          recursive(
            indexLonger + 1,
            0,
            newCurrentLongestLength,
            newLastIterationLength,
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

println(longestCommonSubstringsOptimizedReferentiallyTransparentFP("thisisatest", "testing123testing"))
