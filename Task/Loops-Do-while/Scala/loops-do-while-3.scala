  def loop(i: Int, cond: (Int) => Boolean): Stream[Int] = {
    val succ = i + 1;
    succ #:: (if (cond(succ)) loop(succ, cond) else Stream.empty)
  }
  loop(0, (_ % 6 != 0)).foreach(println(_))
