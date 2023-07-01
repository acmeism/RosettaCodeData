object NumberReversalGame extends App {
  def play(n: Int, cur: List[Int], goal: List[Int]) {
    readLine(s"""$n. ${cur mkString " "}  How many to flip? """) match {
      case null => println
      case s => scala.util.Try(s.toInt) match {
        case scala.util.Success(i) if i > 0 && i <= cur.length =>
          (cur.take(i).reverse ++ cur.drop(i)) match {
            case done if done == goal =>
              println(s"Congratulations! You solved "+goal.mkString(" "))
              println(s"Your score is $n (lower is better)")
            case next => play(n + 1, next, goal)
          }
        case _ => println(s"Choose a number between 1 and ${cur.length}")
          play(n + 1, cur, goal)
      }
    }
  }

  def play(size: Int) {
    val goal = List.range(1, size + 1)
    def init: List[Int] = scala.util.Random.shuffle(goal) match {
      case repeat if repeat == goal => init
      case done => done
    }
    play(1, init, goal)
  }

  play(9)
}
