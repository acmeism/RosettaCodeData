import java.net.URI
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpResponse
import java.util.regex.Pattern
import java.util.stream.Collectors

const val BASE = "http://rosettacode.org"

fun main() {
    val client = HttpClient.newBuilder().build()

    val titleUri = URI.create("$BASE/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks")
    val titleRequest = HttpRequest.newBuilder(titleUri).GET().build()

    val titleResponse = client.send(titleRequest, HttpResponse.BodyHandlers.ofString())
    if (titleResponse.statusCode() == 200) {
        val titleBody = titleResponse.body()

        val titlePattern = Pattern.compile("\"title\": \"([^\"]+)\"")
        val titleMatcher = titlePattern.matcher(titleBody)
        val titleList = titleMatcher.results().map { it.group(1) }.collect(Collectors.toList())

        val headerPattern = Pattern.compile("==\\{\\{header\\|([^}]+)}}==")
        val barePredicate = Pattern.compile("<lang>").asPredicate()

        val countMap = mutableMapOf<String, Int>()
        for (title in titleList) {
            val pageUri = URI("http", null, "//rosettacode.org/wiki", "action=raw&title=$title", null)
            val pageRequest = HttpRequest.newBuilder(pageUri).GET().build()
            val pageResponse = client.send(pageRequest, HttpResponse.BodyHandlers.ofString())
            if (pageResponse.statusCode() == 200) {
                val pageBody = pageResponse.body()

                //println("Title is $title")
                var language = "no language"
                for (line in pageBody.lineSequence()) {
                    val headerMatcher = headerPattern.matcher(line)
                    if (headerMatcher.matches()) {
                        language = headerMatcher.group(1)
                        continue
                    }

                    if (barePredicate.test(line)) {
                        countMap[language] = countMap.getOrDefault(language, 0) + 1
                    }
                }
            } else {
                println("Got a ${titleResponse.statusCode()} status code")
            }
        }

        for (entry in countMap.entries) {
            println("${entry.value} in ${entry.key}")
        }
    } else {
        println("Got a ${titleResponse.statusCode()} status code")
    }
}
