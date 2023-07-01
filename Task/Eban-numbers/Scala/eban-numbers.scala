object EbanNumbers {

  class ERange(s: Int, e: Int, p: Boolean) {
    val start: Int = s
    val end: Int = e
    val print: Boolean = p
  }

  def main(args: Array[String]): Unit = {
    val rgs = List(
      new ERange(2, 1000, true),
      new ERange(1000, 4000, true),
      new ERange(2, 10000, false),
      new ERange(2, 100000, false),
      new ERange(2, 1000000, false),
      new ERange(2, 10000000, false),
      new ERange(2, 100000000, false),
      new ERange(2, 1000000000, false)
    )
    for (rg <- rgs) {
      if (rg.start == 2) {
        println(s"eban numbers up to an including ${rg.end}")
      } else {
        println(s"eban numbers between ${rg.start} and ${rg.end}")
      }

      var count = 0
      for (i <- rg.start to rg.end) {
        val b = i / 1000000000
        var r = i % 1000000000
        var m = r / 1000000
        r = i % 1000000
        var t = r / 1000
        r %= 1000
        if (m >= 30 && m <= 66) {
          m %= 10
        }
        if (t >= 30 && t <= 66) {
          t %= 10
        }
        if (r >= 30 && r <= 66) {
          r %= 10
        }
        if (b == 0 || b == 2 || b == 4 || b == 6) {
          if (m == 0 || m == 2 || m == 4 || m == 6) {
            if (t == 0 || t == 2 || t == 4 || t == 6) {
              if (r == 0 || r == 2 || r == 4 || r == 6) {
                if (rg.print) {
                  print(s"$i ")
                }
                count += 1
              }
            }
          }
        }
      }
      if (rg.print) {
        println()
      }
      println(s"count = $count")
      println()
    }
  }
}
