object VanEck extends App {

  def vanEck(n: Int): List[Int] = {

    def vanEck(values: List[Int]): List[Int] =
      if (values.size < n)
        vanEck(math.max(0, values.indexOf(values.head, 1)) :: values)
      else
        values

    vanEck(List(0)).reverse
  }

  val vanEck1000 = vanEck(1000)
  println(s"The first 10 terms are ${vanEck1000.take(10)}.")
  println(s"Terms 991 to 1000 are ${vanEck1000.drop(990)}.")
}
