import scala.collection.mutable.ListBuffer

object Abundant {
  def divisors(n: Int): ListBuffer[Int] = {
    val divs = new ListBuffer[Int]
    divs.append(1)

    val divs2 = new ListBuffer[Int]
    var i = 2

    while (i * i <= n) {
      if (n % i == 0) {
        val j = n / i
        divs.append(i)
        if (i != j) {
          divs2.append(j)
        }
      }
      i += 1
    }

    divs.appendAll(divs2.reverse)
    divs
  }

  def abundantOdd(searchFrom: Int, countFrom: Int, countTo: Int, printOne: Boolean): Int = {
    var count = countFrom
    var n = searchFrom
    while (count < countTo) {
      val divs = divisors(n)
      val tot = divs.sum
      if (tot > n) {
        count += 1
        if (!printOne || !(count < countTo)) {
          val s = divs.map(a => a.toString).mkString(" + ")
          if (printOne) {
            printf("%d < %s = %d\n", n, s, tot)
          } else {
            printf("%2d. %5d < %s = %d\n", count, n, s, tot)
          }
        }
      }
      n += 2
    }

    n
  }

  def main(args: Array[String]): Unit = {
    val max = 25
    printf("The first %d abundant odd numbers are:\n", max)
    val n = abundantOdd(1, 0, max, printOne = false)

    printf("\nThe one thousandth abundant odd number is:\n")
    abundantOdd(n, 25, 1000, printOne = true)

    printf("\nThe first abundant odd number above one billion is:\n")
    abundantOdd((1e9 + 1).intValue(), 0, 1, printOne = true)
  }
}
