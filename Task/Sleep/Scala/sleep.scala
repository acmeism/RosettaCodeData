object Sleeper extends App {
  print("Enter sleep time in milli sec: ")
  val ms = scala.io.StdIn.readInt()
  println("Sleeping...")
  val sleepStarted = scala.compat.Platform.currentTime
  Thread.sleep(ms)
  println(s"Awaked after [${scala.compat.Platform.currentTime - sleepStarted} ms]1")
}
