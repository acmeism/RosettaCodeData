class LogicPuzzle {
  val s = new Array[Boolean](13)
  var count = 0

  def check2: Boolean = {
    var count = 0
    for (k <- 7 to 12) if (s(k)) count += 1

    s(2) == (count == 3)
  }

  def check3: Boolean = {
    var count = 0
    for (k <- 2 to 12 by 2) if (s(k)) count += 1

    s(3) == (count == 2)
  }

  def check4: Boolean = s(4) == (!s(5) || s(6) && s(7))

  def check5: Boolean = s(5) == (!s(2) && !s(3) && !s(4))

  def check6: Boolean = {
    var count = 0
    for (k <- 1 to 11 by 2) if (s(k)) count += 1
    s(6) == (count == 4)
  }

  def check7: Boolean = s(7) == ((s(2) || s(3)) && !(s(2) && s(3)))

  def check8: Boolean = s(8) == (!s(7) || s(5) && s(6))

  def check9: Boolean = {
    var count = 0
    for (k <- 1 to 6) if (s(k)) count += 1

    s(9) == (count == 3)
  }

  def check10: Boolean = s(10) == (s(11) && s(12))

  def check11: Boolean = {
    var count = 0
    for (k <- 7 to 9) if (s(k)) count += 1

    s(11) == (count == 1)
  }

  def check12: Boolean = {
    var count = 0
    for (k <- 1 to 11) if (s(k)) count += 1
    s(12) == (count == 4)
  }

  def check(): Unit = {
    if (check2 && check3 && check4 && check5 && check6 && check7 && check8 && check9 && check10 && check11 && check12) {
      for (k <- 1 to 12) if (s(k)) print(k + " ")
      println()
      count += 1
    }
  }

  def recurseAll(k: Int): Unit = {
    if (k == 13) check()
    else {
      s(k) = false
      recurseAll(k + 1)
      s(k) = true
      recurseAll(k + 1)
    }
  }
}

object LogicPuzzle extends App {
  val p = new LogicPuzzle
  p.s(1) = true
  p.recurseAll(2)
  println()
  println(s"${p.count} Solutions found.")

}
