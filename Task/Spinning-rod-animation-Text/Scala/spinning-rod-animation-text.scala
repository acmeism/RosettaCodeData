object SpinningRod extends App {
  val start = System.currentTimeMillis

  def a = "|/-\\"

  print("\033[2J") // hide the cursor

  while (System.currentTimeMillis - start < 20000) {
    for (i <- 0 until 4) {
      print("\033[2J\033[0;0H") // clear terminal, place cursor at top left corner
      for (j <- 0 until 80) print(a(i)) // 80 character terminal width, say
      Thread.sleep(250)
    }
  }
  print("\033[?25h") // restore the cursor

}
