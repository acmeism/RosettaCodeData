import java.net.URI
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpResponse
import java.time.Duration
import java.util.regex.Pattern

fun readPage(client: HttpClient, uri: URI): String {
    val request = HttpRequest.newBuilder()
        .GET()
        .uri(uri)
        .timeout(Duration.ofSeconds(5))
        .setHeader("accept", "text/html")
        .build()

    val response = client.send(request, HttpResponse.BodyHandlers.ofString())
    return response.body()
}

fun main() {
    var re = Pattern.compile("<li><a href=\"/wiki/(.*?)\"", Pattern.DOTALL + Pattern.MULTILINE)

    val client = HttpClient.newBuilder()
        .version(HttpClient.Version.HTTP_1_1)
        .followRedirects(HttpClient.Redirect.NORMAL)
        .connectTimeout(Duration.ofSeconds(5))
        .build()

    val uri = URI("http", "rosettacode.org", "/wiki/Category:Programming_Tasks", "")
    var body = readPage(client, uri)
    var matcher = re.matcher(body)

    val tasks = mutableListOf<String>()
    while (matcher.find()) {
        tasks.add(matcher.group(1))
    }

    val base = "http://rosettacode.org/wiki/"
    val limit = 3L
    re = Pattern.compile(".*using any language you may know.</div>(.*?)<div id=\"toc\".*", Pattern.DOTALL + Pattern.MULTILINE)
    val re2 = Pattern.compile("</?[^>]*>")
    for (task in tasks.stream().limit(limit)) {
        val page = base + task
        body = readPage(client, URI(page))

        matcher = re.matcher(body)
        if (matcher.matches()) {
            val group = matcher.group(1)
            val m2 = re2.matcher(group)
            val text = m2.replaceAll("")
            println(text)
        }
    }
}
