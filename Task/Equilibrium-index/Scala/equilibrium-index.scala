 def getEquilibriumIndex(A: Array[Int]): Int = {
      val bigA: Array[BigInt] = A.map(BigInt(_))
      val partialSums: Array[BigInt] = bigA.scanLeft(BigInt(0))(_+_).tail
      def lSum(i: Int): BigInt = if (i == 0) 0 else partialSums(i - 1)
      def rSum(i: Int): BigInt = partialSums.last - partialSums(i)
      def isRandLSumEqual(i: Int): Boolean = lSum(i) == rSum(i)
      (0 until partialSums.length).find(isRandLSumEqual).getOrElse(-1)
    }
