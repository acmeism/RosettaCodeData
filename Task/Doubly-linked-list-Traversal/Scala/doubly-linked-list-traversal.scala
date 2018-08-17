import java.util

object DoublyLinkedListTraversal extends App {

  private val ll = new util.LinkedList[String]

  private def traverse(iter: util.Iterator[String]) =
    while (iter.hasNext) iter.next

  traverse(ll.iterator)
  traverse(ll.descendingIterator)
}
