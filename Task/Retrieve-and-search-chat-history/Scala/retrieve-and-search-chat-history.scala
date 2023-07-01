import java.net.Socket
import java.net.URL
import java.time
import java.time.format
import java.time.ZoneId
import java.util.Scanner
import scala.collection.JavaConverters._

def get(rawUrl: String): List[String] = {
    val url = new URL(rawUrl)
    val port = if (url.getPort > -1) url.getPort else 80
    val sock = new Socket(url.getHost, port)
    sock.getOutputStream.write(
        s"GET /${url.getPath()} HTTP/1.0\n\n".getBytes("UTF-8")
    )
    new Scanner(sock.getInputStream).useDelimiter("\n").asScala.toList
}

def genUrl(n: Long) = {
    val date = java.time.ZonedDateTime
        .now(ZoneId.of("Europe/Berlin"))
        .plusDays(n)
        .format(java.time.format.DateTimeFormatter.ISO_LOCAL_DATE)
    s"http://tclers.tk/conferences/tcl/$date.tcl"
}

val back = 10
val literal = args(0)
for (i <- -back to 0) {
    val url = genUrl(i)
    print(get(url).filter(_.contains(literal)) match {
        case List() => ""
        case x => s"$url\n------\n${x.mkString("\n")}\n------\n\n"
    })
}
