def rate(n: Int, y: Int)(task: => Unit) {
  val startTime = System.currentTimeMillis
  var currTime = startTime
  var loops = 0
  do {
    task
    currTime = System.currentTimeMillis
    loops += 1
  } while (currTime - startTime < n * 1000 && loops < y)
  if (currTime - startTime > n * 1000)
    println("Rate %d times per %d seconds" format (loops - 1, n))
  else
    println("Rate %d times in %.3f seconds" format (y, (currTime - startTime).toDouble / 1000))
}
rate(5, 20)(task(2))
