import java.util.concurrent.SynchronousQueue
import kotlin.concurrent.thread
import java.io.File

const val EOT = "\u0004"  // end of transmission

fun main(args: Array<String>) {
    val queue = SynchronousQueue<String>()

    val work = thread {
        var count = 0

        while (true) {
             val line = queue.take()
             if (line == EOT) {
                queue.put(count.toString())
                break
             }
             println(line)
             count++
        }
    }

    File("input.txt").forEachLine { line -> queue.put(line) }
    queue.put(EOT)
    work.join()

    val count = queue.take().toInt()
    println("\nNumber of lines printed = $count")
}
