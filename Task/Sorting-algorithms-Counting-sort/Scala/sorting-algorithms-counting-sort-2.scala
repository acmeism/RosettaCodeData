def countSort(input: List[Int], min: Int, max: Int): List[Int] =
  input.foldLeft(Array.fill(max - min + 1)(0)) { (arr, n) =>
    arr(n - min) += 1
    arr
  }.zipWithIndex.reverse.foldLeft(List[Int]()) {
    case (lst, (cnt, ndx)) => List.fill(cnt)(ndx + min) ::: lst
  }
