  def tri(row: Int): List[Int] =
    row match {
      case 1 => List(1)
      case n: Int => 1 +: ((tri(n - 1) zip tri(n - 1).tail) map { case (a, b) => a + b }) :+ 1
    }
