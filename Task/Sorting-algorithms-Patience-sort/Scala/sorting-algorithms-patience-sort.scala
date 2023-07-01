import scala.collection.mutable

object PatienceSort extends App {
  def sort[A](source: Iterable[A])(implicit bound: A => Ordered[A]): Iterable[A] = {
    val  piles = mutable.ListBuffer[mutable.Stack[A]]()

    def PileOrdering: Ordering[mutable.Stack[A]] =
      (a: mutable.Stack[A], b: mutable.Stack[A]) => b.head.compare(a.head)

    // Use a priority queue, to simplify extracting minimum elements.
    val pq = new mutable.PriorityQueue[mutable.Stack[A]]()(PileOrdering)

    // Create ordered piles of elements
    for (elem <- source) {
      // Find leftmost "possible" pile
      // If there isn't a pile available, add a new one.
      piles.find(p => p.head >= elem) match {
        case Some(p) => p.push(elem)
        case _ => piles += mutable.Stack(elem)
      }
    }

    pq ++= piles

    // Return a new list, by taking the smallest stack head
    // until all stacks are empty.
    for (_ <- source) yield {
      val smallestList = pq.dequeue
      val smallestVal = smallestList.pop

      if (smallestList.nonEmpty) pq.enqueue(smallestList)
      smallestVal
    }
  }

  println(sort(List(4, 65, 2, -31, 0, 99, 83, 782, 1)))
}
