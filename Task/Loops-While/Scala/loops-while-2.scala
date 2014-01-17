  @tailrec
  def loop(iter: Int) {
    if ((iter > 0)) {
      println(iter)
      loop(iter / 2)
    }
  }
  loop(1024)
