// version 1.1.51

import java.util.concurrent.Semaphore
import kotlin.concurrent.thread

fun main(args: Array<String>) {
    val numPermits = 4
    val numThreads = 9
    val semaphore = Semaphore(numPermits)
    for (i in 1..numThreads) {
        thread {
            val name = "Unit #$i"
            semaphore.acquire()
            println("$name has acquired the semaphore")
            Thread.sleep(2000)
            semaphore.release()
            println("$name has released the semaphore")
        }
    }
}
