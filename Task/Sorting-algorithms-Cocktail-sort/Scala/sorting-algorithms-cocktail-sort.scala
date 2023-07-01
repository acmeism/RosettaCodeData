object CocktailSort extends App {
  def sort(arr: Array[Int]) = {
    var swapped = false
    do {
      def swap(i: Int) {
        val temp = arr(i)
        arr(i) = arr(i + 1)
        arr(i + 1) = temp
        swapped = true
      }

      swapped = false
      for (i <- 0 to (arr.length - 2)) if (arr(i) > arr(i + 1)) swap(i)

      if (swapped) {
        swapped = false
        for (j <- arr.length - 2 to 0 by -1) if (arr(j) > arr(j + 1)) swap(j)
        //if no elements have been swapped, then the list is sorted
      }
    } while (swapped)
    arr
  }

  println(sort(Array(170, 45, 75, -90, -802, 24, 2, 66)).mkString(", "))

}
