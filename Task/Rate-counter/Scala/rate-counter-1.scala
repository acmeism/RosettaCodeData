def task(n: Int) = Thread.sleep(n * 1000)
def rate(fs: List[() => Unit]) = {
  val jobs = fs map (f => scala.actors.Futures.future(f()))
  val cnt1 = scala.actors.Futures.awaitAll(5000, jobs: _*).count(_ != None)
  val cnt2 = scala.actors.Futures.awaitAll(5000, jobs: _*).count(_ != None)
  val cnt3 = scala.actors.Futures.awaitAll(5000, jobs: _*).count(_ != None)
  println("%d jobs in 5 seconds" format cnt1)
  println("%d jobs in 10 seconds" format cnt2)
  println("%d jobs in 15 seconds" format cnt3)
}
rate(List.fill(30)(() => task(scala.util.Random.nextInt(10)+1)))
