import scala.compat.Platform

object Sort_an_integer_array extends App {
  val array = Array((for (i <- 0 to 10) yield scala.util.Random.nextInt()):
    _* /*Sequence is passed as multiple parameters to Array(xs : T*)*/)

  /** Function test the array if it is in order */
  def isSorted[T](arr: Array[T]) = array.sliding(2).forall(pair => pair(0) <= pair(1))

  assert(!isSorted(array), "Not random")
  scala.util.Sorting.quickSort(array)
  assert(isSorted(array), "Not sorted")

  println(s"Array in sorted order.\nSuccessfully completed without errors. [total ${Platform.currentTime - executionStart} ms]")
}
