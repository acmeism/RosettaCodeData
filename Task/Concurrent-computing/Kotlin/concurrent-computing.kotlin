// version 1.1.2

import java.util.concurrent.CyclicBarrier

class DelayedMessagePrinter(val barrier: CyclicBarrier, val msg: String) : Runnable {
    override fun run() {
        barrier.await()
        println(msg)
    }
}

fun main(args: Array<String>) {
    val msgs = listOf("Enjoy", "Rosetta", "Code")
    val barrier = CyclicBarrier(msgs.size)
    for (msg in msgs) Thread(DelayedMessagePrinter(barrier, msg)).start()
}
