import scala.collection.mutable.ListBuffer

object RangeModifications extends App {

  var ranges = new Ranges(List.empty)
  println(s"Initial ranges = $ranges")
  displayAdd(ranges, 77)
  displayAdd(ranges, 79)
  displayAdd(ranges, 78)
  displayRemove(ranges, 77)
  displayRemove(ranges, 78)
  displayRemove(ranges, 79)

  ranges = new Ranges(List(Range(1, 3), Range(5, 5)))
  println(s"\nInitial ranges = $ranges")
  displayAdd(ranges, 1)
  displayRemove(ranges, 4)
  displayAdd(ranges, 7)
  displayAdd(ranges, 8)
  displayAdd(ranges, 6)
  displayRemove(ranges, 7)

  ranges = new Ranges(List(Range(1, 5), Range(10, 25), Range(27, 30)))
  println(s"\nInitial ranges = $ranges")
  displayAdd(ranges, 26)
  displayAdd(ranges, 9)
  displayAdd(ranges, 7)
  displayRemove(ranges, 26)
  displayRemove(ranges, 9)
  displayRemove(ranges, 7)

  private def displayAdd(ranges: Ranges, n: Int): Unit = {
    ranges.add(n)
    println(f"       add $n%2d => $ranges")
  }

  private def displayRemove(ranges: Ranges, n: Int): Unit = {
    ranges.remove(n)
    println(f"    remove $n%2d => $ranges")
  }
}

class Ranges(initialRanges: List[Range]) {
  private val ranges = ListBuffer(initialRanges: _*)

  def add(n: Int): Unit = {
    var i = 0
    var inserted = false

    while (i < ranges.length && !inserted) {
      val current = ranges(i)

      if (n + 1 < current.low) {
        ranges.insert(i, Range(n, n))
        inserted = true
      } else if (n + 1 == current.low) {
        current.low = n
        inserted = true
      } else if (n <= current.high) {
        // No action required - number already in range
        inserted = true
      } else if (n - 1 == current.high) {
        current.high = n
        // Check if we need to merge with next range
        if (i + 1 < ranges.length) {
          val next = ranges(i + 1)
          if (n == next.low || n + 1 == next.low) {
            current.high = next.high
            ranges.remove(i + 1)
          }
        }
        inserted = true
      } else if (i == ranges.length - 1) {
        ranges += Range(n, n)
        inserted = true
      }

      i += 1
    }

    if (!inserted) {
      ranges += Range(n, n)
    }
  }

  def remove(n: Int): Unit = {
    var i = 0

    while (i < ranges.length) {
      val current = ranges(i)
      var removed = false

      if (n == current.low) {
        current.low = n + 1
        if (current.low > current.high) {
          ranges.remove(i)
          removed = true
        }
      } else if (n == current.high) {
        current.high = n - 1
        if (current.high < current.low) {
          ranges.remove(i)
          removed = true
        }
      } else if (n > current.low && n < current.high) {
        val high = current.high
        current.high = n - 1
        ranges.insert(i + 1, Range(n + 1, high))
      }

      if (!removed) i += 1
    }
  }

  override def toString: String = ranges.mkString("[", ", ", "]")
}

case class Range(var low: Int, var high: Int) {
  override def toString: String = s"$low-$high"
}
