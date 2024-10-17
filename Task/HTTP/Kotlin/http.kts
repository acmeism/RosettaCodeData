// version 1.1.2

import java.net.URL
import java.io.InputStreamReader
import java.util.Scanner

fun main(args: Array<String>) {
    val url = URL("http://www.puzzlers.org/pub/wordlists/unixdict.txt")
    val isr = InputStreamReader(url.openStream())
    val sc = Scanner(isr)
    while (sc.hasNextLine()) println(sc.nextLine())
    sc.close()
}
