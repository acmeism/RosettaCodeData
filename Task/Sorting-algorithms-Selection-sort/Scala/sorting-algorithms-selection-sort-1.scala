def swap(a: Array[Int], i1: Int, i2: Int) = { val tmp = a(i1); a(i1) = a(i2); a(i2) = tmp }

def selectionSort(a: Array[Int]) =
  for (i <- 0 until a.size - 1)
    swap(a, i, (i + 1 until a.size).foldLeft(i)((currMin, index) =>
      if (a(index) < a(currMin)) index else currMin))
