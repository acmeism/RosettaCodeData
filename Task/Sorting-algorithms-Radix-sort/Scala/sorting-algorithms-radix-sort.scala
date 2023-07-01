object RadixSort extends App {
  def sort(toBeSort: Array[Int]): Array[Int] = { // Loop for every bit in the integers
    var arr = toBeSort
    for (shift <- Integer.SIZE - 1 until -1 by -1) { // The array to put the partially sorted array into
      val tmp = new Array[Int](arr.length)
      // The number of 0s
      var j = 0
      // Move the 0s to the new array, and the 1s to the old one
      for (i <- arr.indices) // If there is a 1 in the bit we are testing, the number will be negative
        // If this is the last bit, negative numbers are actually lower
        if ((shift == 0) == (arr(i) << shift >= 0)) arr(i - j) = arr(i)
        else {
          tmp(j) = arr(i)
          j += 1
        }
      // Copy over the 1s from the old array
      arr.copyToArray(tmp, j, arr.length - j)

      // And now the tmp array gets switched for another round of sorting
      arr = tmp
    }
    arr
  }

  println(sort(Array(170, 45, 75, -90, -802, 24, 2, 66)).mkString(", "))
}
