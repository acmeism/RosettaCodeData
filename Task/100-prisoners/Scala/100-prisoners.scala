import scala.util.Random
import scala.util.control.Breaks._

object Main {
  def playOptimal(n: Int): Boolean = {
    val secretList = Random.shuffle((0 until n).toBuffer)

    for (i <- secretList.indices) {
      var prev = i
      breakable {
        for (_ <- 0 until secretList.size / 2) {
          if (secretList(prev) == i) {
            break()
          }
          prev = secretList(prev)
        }
        return false
      }
    }

    true
  }

  def playRandom(n: Int): Boolean = {
    val secretList = Random.shuffle((0 until n).toBuffer)

    for (i <- secretList.indices) {
      val trialList = Random.shuffle((0 until n).toBuffer)

      breakable {
        for (j <- 0 until trialList.size / 2) {
          if (trialList(j) == i) {
            break()
          }
        }
        return false
      }
    }

    true
  }

  def exec(n: Int, p: Int, play: Int => Boolean): Double = {
    var succ = 0.0
    for (_ <- 0 until n) {
      if (play(p)) {
        succ += 1
      }
    }
    (succ * 100.0) / n
  }

  def main(args: Array[String]): Unit = {
    val n = 100000
    val p = 100
    printf("# of executions: %,d\n", n)
    printf("Optimal play success rate: %f%%\n", exec(n, p, playOptimal))
    printf("Random play success rate: %f%%\n", exec(n, p, playRandom))
  }
}
