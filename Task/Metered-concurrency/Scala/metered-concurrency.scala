class CountingSemaphore(var maxCount: Int) {
  private var lockCount = 0

  def acquire(): Unit = {
    while ( {
      lockCount >= maxCount
    }) wait()
    lockCount += 1
  }

  def release(): Unit = {
    if (lockCount > 0) {
      lockCount -= 1
      notifyAll()
    }
  }

  def getCount: Int = lockCount
}

object Worker {
  def main(args: Array[String]): Unit = {
    val (lock, crew) = (new CountingSemaphore(3), new Array[Worker](5))

    for { i <- 0 until 5} {
      crew(i) = new Worker(lock, i)
      crew(i).start()
    }
  }
}
