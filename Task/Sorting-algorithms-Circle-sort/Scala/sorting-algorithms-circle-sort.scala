object CircleSort extends App {

  def sort(arr: Array[Int]): Array[Int] = {
    def circleSortR(arr: Array[Int], _lo: Int, _hi: Int, _numSwaps: Int): Int = {
      var lo = _lo
      var hi = _hi
      var numSwaps = _numSwaps

      def swap(arr: Array[Int], idx1: Int, idx2: Int): Unit = {
        val tmp = arr(idx1)
        arr(idx1) = arr(idx2)
        arr(idx2) = tmp
      }

      if (lo == hi) return numSwaps
      val (high, low) = (hi, lo)
      val mid = (hi - lo) / 2
      while ( lo < hi) {
        if (arr(lo) > arr(hi)) {
          swap(arr, lo, hi)
          numSwaps += 1
        }
        lo += 1
        hi -= 1
      }
      if (lo == hi && arr(lo) > arr(hi + 1)) {
        swap(arr, lo, hi + 1)
        numSwaps += 1
      }

      circleSortR(arr, low + mid + 1, high, circleSortR(arr, low, low + mid, numSwaps))
    }

    while (circleSortR(arr, 0, arr.length - 1, 0) != 0)()
    arr
  }

  println(sort(Array[Int](2, 14, 4, 6, 8, 1, 3, 5, 7, 11, 0, 13, 12, -1)).mkString(", "))

}
