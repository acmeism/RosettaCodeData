import java.util.{Random, Scanner}

object CheckpointSync extends App {
  val in = new Scanner(System.in)

  /*
   * Informs that workers started working on the task and
   * starts running threads. Prior to proceeding with next
   * task syncs using static Worker.checkpoint() method.
   */
  private def runTasks(nTasks: Int): Unit = {

    for (i <- 0 until nTasks) {
      println("Starting task number " + (i + 1) + ".")
      runThreads()
      Worker.checkpoint()
    }
  }

  /*
   * Creates a thread for each worker and runs it.
   */
  private def runThreads(): Unit =
    for (i <- 0 until Worker.nWorkers) new Thread(new Worker(i + 1)).start()

  class Worker(/* inner class instance variables */ var threadID: Int)
    extends Runnable {
    override def run(): Unit = {
      work()
    }

    /*
     *  Notifies that thread started running for 100 to 1000 msec.
     *  Once finished increments static counter 'nFinished'
     *  that counts number of workers finished their work.
     */
    private def work(): Unit = {
      try {
        val workTime = Worker.rgen.nextInt(900) + 100
        println("Worker " + threadID + " will work for " + workTime + " msec.")
        Thread.sleep(workTime) //work for 'workTime'

        Worker.nFinished += 1 //increases work finished counter

        println("Worker " + threadID + " is ready")
      } catch {
        case e: InterruptedException =>
          System.err.println("Error: thread execution interrupted")
          e.printStackTrace()
      }
    }
  }

  /*
   * Worker inner static class.
   */
  object Worker {
    private val rgen = new Random
    var nWorkers = 0
    private var nFinished = 0

    /*
     * Used to synchronize Worker threads using 'nFinished' static integer.
     * Waits (with step of 10 msec) until 'nFinished' equals to 'nWorkers'.
     * Once they are equal resets 'nFinished' counter.
     */
    def checkpoint(): Unit = {
      while (nFinished != nWorkers)
        try Thread.sleep(10)
        catch {
          case e: InterruptedException =>
            System.err.println("Error: thread execution interrupted")
            e.printStackTrace()
        }
      nFinished = 0
    }
  }

  print("Enter number of workers to use: ")
  Worker.nWorkers = in.nextInt
  print("Enter number of tasks to complete:")
  runTasks(in.nextInt)

}
