import scala.collection.mutable.ListBuffer
import scala.util.Random

object CardShuffles {
  val rand = new Random()

  def riffleShuffle[T](source: List[T], flips: Int): List[T] = {
    val list = source.to[ListBuffer]
    for (_ <- 1 to flips) {
      //cut the deck at the middle +/- 10%, remove the second line of the formula for perfect cutting
      val cutPoint = list.size / 2 + (if (rand.nextBoolean()) -1 else 1) * rand.nextInt((list.size * 0.1).toInt)

      //split the deck
      val left = list.slice(0, cutPoint)
      val right = list.slice(cutPoint, list.size)

      list.clear()
      while (left.nonEmpty && right.nonEmpty) {
        //allow for imperfect riffling so that more than one card can come form the same side in a row
        //biased towards the side with more cards
        //remove the if and else and brackets for perfect riffling
        if (rand.nextDouble() >= (1.0 * left.size / right.size) / 2.0) {
          list.append(right.remove(0))
        } else {
          list.append(left.remove(0))
        }
      }

      //if either hand is out of cards then flip all of the other hand to the shuffled deck
      if (left.nonEmpty) list.appendAll(left)
      if (right.nonEmpty) list.appendAll(right)
    }
    list.toList
  }

  def overhandShuffle[T](source: List[T], passes: Int): List[T] = {
    var mainHand = source.to[ListBuffer]
    for (_ <- 1 to passes) {
      val otherHand = new ListBuffer[T]

      while (mainHand.nonEmpty) {
        //cut at up to 20% of the way through the deck
        val cutSize = rand.nextInt((source.size * 0.2).toInt) + 1

        val temp = new ListBuffer[T]

        //grab the next cut up to the end of the cards left in the main hand
        var i = 0
        while (i < cutSize && mainHand.nonEmpty) {
          temp.append(mainHand.remove(0))
          i = i + 1
        }

        //add them to the cards in the other hand, sometimes to the front sometimes to the back
        if (rand.nextDouble() >= 0.1) {
          //front most of the time
          otherHand.insertAll(0, temp)
        } else {
          //end sometimes
          otherHand.appendAll(temp)
        }
      }

      //move the cards back to the main hand
      mainHand = otherHand
    }
    mainHand.toList
  }

  def main(args: Array[String]): Unit = {
    // riffle shuffle
    var lst = (1 to 20).toList
    println(lst)
    var sorted = riffleShuffle(lst, 10)
    println(sorted)
    println()

    lst = (1 to 20).toList
    println(lst)
    sorted = riffleShuffle(lst, 1)
    println(sorted)
    println()

    // overhand shuffle
    lst = (1 to 20).toList
    println(lst)
    sorted = overhandShuffle(lst, 10)
    println(sorted)
    println()

    lst = (1 to 20).toList
    println(lst)
    sorted = overhandShuffle(lst, 1)
    println(sorted)
    println()

    // builtin
    lst = (1 to 20).toList
    println(lst)
    sorted = Random.shuffle(lst)
    println(sorted)
    println()
  }
}
