// Version 1.2.41

import java.util.Random

val rgen = Random()
var nWorkers = 0
var nTasks = 0

class Worker(private val threadID: Int) : Runnable {

    @Synchronized
    override fun run() {
        try {
            val workTime = rgen.nextInt(900) + 100L  // 100..999 msec.
            println("Worker $threadID will work for $workTime msec.")
            Thread.sleep(workTime)
            nFinished++
            println("Worker $threadID is ready")
        }
        catch (e: InterruptedException) {
            println("Error: thread execution interrupted")
            e.printStackTrace()
        }
    }

    companion object {
        private var nFinished = 0

        @Synchronized
        fun checkPoint() {
            while (nFinished != nWorkers) {
                try {
                    Thread.sleep(10)
                }
                catch (e: InterruptedException) {
                    println("Error: thread execution interrupted")
                    e.printStackTrace()
                }
            }
            nFinished = 0  // reset
        }
    }
}

fun runTasks() {
    for (i in 1..nTasks) {
        println("\nStarting task number $i.")
        // Create a thread for each worker and run it.
        for (j in 1..nWorkers) Thread(Worker(j)).start()
        Worker.checkPoint()  // wait for all workers to finish the task
    }
}

fun main(args: Array<String>) {
    print("Enter number of workers to use: ")
    nWorkers = readLine()!!.toInt()
    print("Enter number of tasks to complete: ")
    nTasks = readLine()!!.toInt()
    runTasks()
}
