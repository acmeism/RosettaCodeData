import scala.util.control.Breaks._


object YellowstoneSequence extends App {

  println(s"First 30 values in the yellowstone sequence:\n${yellowstoneSequence(30)}")

  def yellowstoneSequence(sequenceCount: Int): List[Int] = {
    var yellowstoneList = List(1, 2, 3)
    var num = 4
    var notYellowstoneList = List[Int]()

    while (yellowstoneList.size < sequenceCount) {
      val foundIndex = notYellowstoneList.indexWhere(test =>
        gcd(yellowstoneList(yellowstoneList.size - 2), test) > 1 &&
        gcd(yellowstoneList.last, test) == 1
      )

      if (foundIndex >= 0) {
        yellowstoneList = yellowstoneList :+ notYellowstoneList(foundIndex)
        notYellowstoneList = notYellowstoneList.patch(foundIndex, Nil, 1)
      } else {
        breakable({
        while (true) {
          if (gcd(yellowstoneList(yellowstoneList.size - 2), num) > 1 &&
              gcd(yellowstoneList.last, num) == 1) {
            yellowstoneList = yellowstoneList :+ num
            num += 1
            // break the inner while loop
            break
          }
          notYellowstoneList = notYellowstoneList :+ num
          num += 1
        }
        });
      }
    }
    yellowstoneList
  }

  def gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)
}
