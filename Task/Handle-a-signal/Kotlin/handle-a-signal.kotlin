// version 1.1.3

import sun.misc.Signal
import sun.misc.SignalHandler

fun main(args: Array<String>) {
    val startTime = System.currentTimeMillis()

    Signal.handle(Signal("INT"), object : SignalHandler {
        override fun handle(sig: Signal) {
            val elapsedTime = (System.currentTimeMillis() - startTime) / 1000.0
            println("\nThe program has run for $elapsedTime seconds")
            System.exit(0)
        }
    })

    var i = 0
    while(true) {
        println(i++)
        Thread.sleep(500)
    }
}
