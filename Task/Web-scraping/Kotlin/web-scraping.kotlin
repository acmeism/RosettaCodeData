// version 1.1.3

import java.net.URL
import java.io.InputStreamReader
import java.util.Scanner

fun main(args: Array<String>) {
    val url = URL("http://tycho.usno.navy.mil/cgi-bin/timer.pl")
    val isr = InputStreamReader(url.openStream())
    val sc = Scanner(isr)
    while (sc.hasNextLine()) {
        val line = sc.nextLine()
        if ("UTC" in line) {
            println(line.drop(4).take(17))
            break
        }
    }
    sc.close()
}
