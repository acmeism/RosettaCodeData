object StoogeSort extends App {
  def stoogeSort(a: Array[Int], i: Int, j: Int) {
    if (a(j) < a(i)) {
      val temp = a(j)
      a(j) = a(i)
      a(i) = temp
    }
    if (j - i > 1) {
      val t = (j - i + 1) / 3
      stoogeSort(a, i, j - t)
      stoogeSort(a, i + t, j)
      stoogeSort(a, i, j - t)
    }
  }

  val a = Array(100, 2, 56, 200, -52, 3, 99, 33, 177, -199)
  println(s"Original : ${a.mkString(", ")}")
  stoogeSort(a, 0, a.length - 1)
  println(s"Sorted   : ${a.mkString(", ")}")
}
