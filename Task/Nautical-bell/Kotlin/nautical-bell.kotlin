// version 1.1.3

import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.TimeZone

class NauticalBell: Thread() {

    override fun run() {
        val sdf = SimpleDateFormat("HH:mm:ss")
        sdf.timeZone = TimeZone.getTimeZone("UTC")
        var numBells = 0
        var time = System.currentTimeMillis()
        var next = time - (time % (24 * 60 * 60 * 1000)) // midnight

        while (next < time) {
            next += 30 * 60 * 1000 // 30 minutes
            numBells = 1 + (numBells % 8)
        }

        while (true) {
            var wait = 100L
            time = System.currentTimeMillis()
            if ((time - next) >= 0) {
                val bells = if (numBells == 1) "bell" else "bells"
                val timeString = sdf.format(time)
                println("%s : %d %s".format(timeString, numBells, bells))
                next += 30 * 60 * 1000
                wait = next - time
                numBells = 1 + (numBells % 8)
            }
            try {
                Thread.sleep(wait)
            }
            catch (ie: InterruptedException) {
                return
            }
        }
    }
}

fun main(args: Array<String>) {
    val bells = NauticalBell()
    with (bells) {
        setDaemon(true)
        start()
        try {
            join()
        }
        catch (ie: InterruptedException) {
            println(ie.message)
        }
    }
}
