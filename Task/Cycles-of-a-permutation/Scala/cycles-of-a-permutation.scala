import scala.collection.mutable.ListBuffer
import scala.util.chaining._

object CyclesOfAPermutation {

  sealed trait Day {
    def letters: String
    def previous: Day = Day.values.takeWhile(_ != this).lastOption.getOrElse(Day.values.last)
  }

  object Day {
    case object Monday extends Day { val letters = "HANDYCOILSERUPT" }
    case object Tuesday extends Day { val letters = "SPOILUNDERYACHT" }
    case object Wednesday extends Day { val letters = "DRAINSTYLEPOUCH" }
    case object Thursday extends Day { val letters = "DITCHSYRUPALONE" }
    case object Friday extends Day { val letters = "SOAPYTHIRDUNCLE" }
    case object Saturday extends Day { val letters = "SHINEPARTYCLOUD" }
    case object Sunday extends Day { val letters = "RADIOLUNCHTYPES" }

    val values: Array[Day] = Array(Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday)
  }

  def main(args: Array[String]): Unit = {
    val permutation = new Permutation(Day.Monday.letters.length)

    println("On Thursdays Alf and Betty should rearrange their letters using these cycles:")
    val oneLineWedThu = permutation.createOneLine(Day.Wednesday.letters, Day.Thursday.letters)
    val cyclesWedThu = permutation.oneLineToCycles(oneLineWedThu)
    println(cyclesWedThu)
    println(s"So that ${Day.Wednesday.letters} becomes ${Day.Thursday.letters}")

    println("\nOr they could use the one line notation:")
    println(oneLineWedThu)

    println("\nTo revert to the Wednesday arrangement they should use these cycles:")
    val cyclesThuWed = permutation.cyclesInverse(cyclesWedThu)
    println(cyclesThuWed)

    println("\nOr with the one line notation:")
    val oneLineThuWed = permutation.oneLineInverse(oneLineWedThu)
    println(oneLineThuWed)
    println(s"So that ${Day.Thursday.letters} becomes ${permutation.oneLinePermuteString(Day.Thursday.letters, oneLineThuWed)}")

    println("\nStarting with the Sunday arrangement and applying each of the daily")
    println("arrangements consecutively, the arrangements will be:")
    println(s"\n      ${Day.Sunday.letters}\n")

    Day.values.foreach { day =>
      val dayOneLine = permutation.createOneLine(day.previous.letters, day.letters)
      val result = permutation.oneLinePermuteString(day.previous.letters, dayOneLine)
      val spacing = if (day == Day.Saturday) "\n" else ""
      println(f"${day.toString.toUpperCase}%11s: $result$spacing")
    }

    println("\nTo go from Wednesday to Friday in a single step they should use these cycles:")
    val oneLineThuFri = permutation.createOneLine(Day.Thursday.letters, Day.Friday.letters)
    val cyclesThuFri = permutation.oneLineToCycles(oneLineThuFri)
    val cyclesWedFri = permutation.combinedCycles(cyclesWedThu, cyclesThuFri)
    println(cyclesWedFri)
    println(s"So that ${Day.Wednesday.letters} becomes ${permutation.cyclesPermuteString(Day.Wednesday.letters, cyclesWedFri)}")

    println("\nThese are the signatures of the permutations:\n")
    Day.values.foreach { day =>
      val oneLine = permutation.createOneLine(day.previous.letters, day.letters)
      println(f"${day.toString.toUpperCase}%11s: ${permutation.signature(oneLine)}")
    }

    println("\nThese are the orders of the permutations:\n")
    Day.values.foreach { day =>
      val oneLine = permutation.createOneLine(day.previous.letters, day.letters)
      println(f"${day.toString.toUpperCase}%11s: ${permutation.order(oneLine)}")
    }

    println("\nApplying the Friday cycle to a string 10 times:")
    var word = "STOREDAILYPUNCH"
    println(s"\n 0 $word\n")

    (1 to 10).foreach { i =>
      word = permutation.cyclesPermuteString(word, cyclesThuFri)
      val spacing = if (i == 9) "\n" else ""
      println(f"$i%2d $word$spacing")
    }
  }
}

class Permutation(lettersCount: Int) {

  // Return the permutation in one line form that transforms the string 'source' into the string 'destination'.
  def createOneLine(source: String, destination: String): List[Int] = {
    val result = ListBuffer[Int]()
    destination.foreach { ch =>
      result += source.indexOf(ch) + 1
    }

    while (result.nonEmpty && result.last == result.size) {
      result.remove(result.size - 1)
    }

    result.toList
  }

  // Return the cycles of the permutation given in one line form.
  def oneLineToCycles(oneLine: List[Int]): List[List[Int]] = {
    val cycles = ListBuffer[List[Int]]()
    val used = scala.collection.mutable.Set[Int]()

    var number = 1
    while (used.size < oneLine.size) {
      if (!used.contains(number)) {
        val index = oneLine.indexOf(number) + 1

        if (index > 0) {
          val cycle = ListBuffer[Int]()
          cycle += number
          var currentIndex = index

          while (number != currentIndex) {
            cycle += currentIndex
            currentIndex = oneLine.indexOf(currentIndex) + 1
          }

          if (cycle.size > 1) {
            cycles += cycle.toList
          }
          used ++= cycle
        }
      }
      number += 1
    }

    cycles.toList
  }

  // Return the one line notation of the permutation given in cycle form.
  def cyclesToOneLine(cycles: List[List[Int]]): List[Int] = {
    val oneLine = (1 to lettersCount).toArray

    for (number <- 1 to lettersCount) {
      cycles.find(_.contains(number)) match {
        case Some(cycle) =>
          val index = cycle.indexOf(number)
          oneLine(number - 1) = cycle((index - 1 + cycle.size) % cycle.size)
        case None => // number stays in place
      }
    }

    oneLine.toList
  }

  // Return the inverse of the given permutation in cycle form.
  def cyclesInverse(cycles: List[List[Int]]): List[List[Int]] = {
    cycles.map { cycle =>
      val inverseCycle = cycle.tail :+ cycle.head
      inverseCycle.reverse
    }
  }

  // Return the inverse of the given permutation in one line notation.
  def oneLineInverse(oneLine: List[Int]): List[Int] = {
    val oneLineInverse = Array.fill(oneLine.size)(0)

    for (number <- 1 to oneLine.size) {
      oneLineInverse(number - 1) = oneLine.indexOf(number) + 1
    }

    oneLineInverse.toList
  }

  // Return the cycles obtained by composing cycleOne first followed by cycleTwo.
  def combinedCycles(cyclesOne: List[List[Int]], cyclesTwo: List[List[Int]]): List[List[Int]] = {
    val combinedCycles = ListBuffer[List[Int]]()
    val used = scala.collection.mutable.Set[Int]()

    var number = 1
    while (used.size < lettersCount) {
      if (!used.contains(number)) {
        val combined = next(next(number, cyclesOne), cyclesTwo)
        val cycle = ListBuffer[Int]()
        cycle += number
        var current = combined

        while (number != current) {
          cycle += current
          current = next(next(current, cyclesOne), cyclesTwo)
        }

        if (cycle.size > 1) {
          combinedCycles += cycle.toList
        }
        used ++= cycle
      }
      number += 1
    }

    combinedCycles.toList
  }

  // Return the given string permuted by the permutation given in one line form.
  def oneLinePermuteString(text: String, oneLine: List[Int]): String = {
    val permuted = ListBuffer[String]()

    oneLine.foreach { index =>
      permuted += text.substring(index - 1, index)
    }
    permuted += text.substring(permuted.size)

    permuted.mkString
  }

  // Return the given string permuted by the permutation given in cycle form.
  def cyclesPermuteString(text: String, cycles: List[List[Int]]): String = {
    val permuted = text.toCharArray

    cycles.foreach { cycle =>
      cycle.foreach { number =>
        permuted(next(number, cycles) - 1) = text.charAt(number - 1)
      }
    }

    permuted.mkString
  }

  // Return the signature of the permutation given in one line form.
  def signature(oneLine: List[Int]): String = {
    val cycles = oneLineToCycles(oneLine)
    val evenCount = cycles.count(_.size % 2 == 0)

    if (evenCount % 2 == 0) "+1" else "-1"
  }

  // Return the order of the permutation given in one line form.
  def order(oneLine: List[Int]): Int = {
    val cycles = oneLineToCycles(oneLine)
    val sizes = cycles.map(_.size)

    sizes.foldLeft(1)((acc, size) => acc * (size / gcd(acc, size)))
  }

  // Return the element to which the given number is mapped by the permutation given in cycle form.
  private def next(number: Int, cycles: List[List[Int]]): Int = {
    cycles.find(_.contains(number)) match {
      case Some(cycle) =>
        val index = cycle.indexOf(number)
        cycle((index + 1) % cycle.size)
      case None => number
    }
  }

  // Return the greatest common divisor of the two given numbers.
  private def gcd(one: Int, two: Int): Int = {
    if (two == 0) one else gcd(two, one % two)
  }
}
