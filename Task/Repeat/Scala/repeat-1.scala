  def repeat[A](n:Int)(f: => A)= ( 0 until n).foreach(_ => f)

  repeat(3) { println("Example") }
