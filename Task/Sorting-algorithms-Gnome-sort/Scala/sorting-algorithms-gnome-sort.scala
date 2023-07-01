object GnomeSort {
  def gnomeSort(a: Array[Int]): Unit = {
    var (i, j) = (1, 2)
    while ( i < a.length)
      if (a(i - 1) <= a(i)) { i = j; j += 1 }
    else {
      val tmp = a(i - 1)
      a(i - 1) = a(i)
      a({i -= 1; i + 1}) = tmp
      i = if (i == 0) {j += 1; j - 1} else i
    }
  }
}
