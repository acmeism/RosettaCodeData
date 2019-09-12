object NQueens {

  private implicit class RichPair[T](
    pair: (T,T))(
    implicit num: Numeric[T]
  ) {
    import num._

    def safe(x: T, y: T): Boolean =
      pair._1 - pair._2 != abs(x - y)
  }

  def solve(n: Int): Iterator[Seq[Int]] = {
    (0 to n-1)
      .permutations
      .filter { v =>
        (0 to n-1).forall { y =>
          (y+1 to n-1).forall { x =>
            (x,y).safe(v(x),v(y))
          }
        }
      }
  }

  def main(args: Array[String]): Unit = {
    val n = args.headOption.getOrElse("8").toInt
    val (solns1, solns2) = solve(n).duplicate
    solns1
      .zipWithIndex
      .foreach { case (soln, i) =>
        Console.out.println(s"Solution #${i+1}")
        output(n)(soln)
      }
    val n_solns = solns2.size
    if (n_solns == 1) {
      Console.out.println("Found 1 solution")
    } else {
      Console.out.println(s"Found $n_solns solutions")
    }
  }

  def output(n: Int)(board: Seq[Int]): Unit = {
    board.foreach { queen =>
      val row =
        "_|" * queen + "Q" + "|_" * (n-queen-1)
      Console.out.println(row)
    }
  }
}
