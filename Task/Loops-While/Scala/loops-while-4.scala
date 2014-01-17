  def loop(i: Int): Stream[Int] = i #:: (if (i > 0) loop(i / 2) else Stream.empty)
  loop(1024).takeWhile(_ > 0).foreach(println(_))
