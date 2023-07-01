import scala.compat.Platform

object SortedDisjointSubList extends App {
  val (list, subListIndex) = (List(7, 6, 5, 4, 3, 2, 1, 0), List(6, 1, 7))

  def sortSubList[T: Ordering](indexList: List[Int], list: List[T]) = {
    val subListIndex = indexList.sorted
    val sortedSubListMap = subListIndex.zip(subListIndex.map(list(_)).sorted).toMap

    list.zipWithIndex.map { case (value, index) =>
      if (sortedSubListMap.isDefinedAt(index)) sortedSubListMap(index) else value
    }
  }

  assert(sortSubList(subListIndex, list) == List(7, 0, 5, 4, 3, 2, 1, 6), "Incorrect sort")
  println(s"List in sorted order.\nSuccessfully completed without errors. [total ${Platform.currentTime - executionStart} ms]")
}
