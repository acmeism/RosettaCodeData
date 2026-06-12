import scala.util.Random
import scala.util.control.Breaks._

object Test {

  def equalBirthdays(
      nSharers: Int,
      groupSize: Int,
      nRepetitions: Int
  ): Double = {
    val rand = new Random(1)
    var eq = 0

    for (_ <- 1 to nRepetitions) {
      val group = new Array[Int](365)
      for (_ <- 1 to groupSize) {
        val birthday = rand.nextInt(group.length)
        group(birthday) += 1
      }
      if (group.exists(_ >= nSharers)) eq += 1
    }

    (eq * 100.0) / nRepetitions
  }

  def main(args: Array[String]): Unit = {
    var groupEst = 2

    for (sharers <- 2 until 6) {
      // Coarse.
      var groupSize = groupEst + 1
      while (equalBirthdays(sharers, groupSize, 100) < 50.0)
        groupSize += 1

      // Finer.
      val inf = (groupSize - (groupSize - groupEst) / 4.0).toInt
      breakable({
        for (gs <- inf until groupSize + 999) {
          val eq = equalBirthdays(sharers, groupSize, 250)
          if (eq > 50.0) {
            groupSize = gs
            break
          }
        }
      })

      // Finest.
      breakable({
        for (gs <- (groupSize - 1) until groupSize + 999) {
          val eq = equalBirthdays(sharers, gs, 50000)
          if (eq > 50.0) {
            groupEst = gs
            println(
              f"$sharers independent people in a group of $gs share a common birthday. ($eq%5.1f)"
            )
            break
          }
        }
      })
    }
  }
}
