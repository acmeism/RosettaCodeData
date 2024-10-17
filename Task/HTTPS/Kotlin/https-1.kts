// version 1.1.2
import java.net.URL
import javax.net.ssl.HttpsURLConnection
import java.io.InputStreamReader
import java.util.Scanner

fun main(args: Array<String>) {
    val url = URL("https://en.wikipedia.org/wiki/Main_Page")
    val connection = url.openConnection() as HttpsURLConnection
    val isr = InputStreamReader(connection.inputStream)
    val sc = Scanner(isr)
    while (sc.hasNextLine()) println(sc.nextLine())
    sc.close()
}
