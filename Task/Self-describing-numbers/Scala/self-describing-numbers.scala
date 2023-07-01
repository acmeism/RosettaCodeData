object SelfDescribingNumbers extends App {
  def isSelfDescribing(a: Int): Boolean = {
    val s = Integer.toString(a)

    (0 until s.length).forall(i => s.count(_.toString.toInt == i) == s(i).toString.toInt)
  }

  println("Curious numbers n = x0 x1 x2...x9 such that xi is the number of digits equal to i in n.")

  for (i <- 0 to 42101000 by 10
       if isSelfDescribing(i)) println(i)

  println("Successfully completed without errors.")
}
