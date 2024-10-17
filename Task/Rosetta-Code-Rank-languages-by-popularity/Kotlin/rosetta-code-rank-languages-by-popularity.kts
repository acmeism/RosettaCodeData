import java.net.URL
import java.io.*

object Popularity {
    /** Gets language data. */
    fun ofLanguages(): List<String> {
        val languages = mutableListOf<String>()
        var gcm = ""
        do {
            val path = url + (if (gcm == "") "" else "&gcmcontinue=" + gcm) + "&prop=categoryinfo" + "&format=txt"
            try {
                val rc = URL(path).openConnection() // URL completed, connection opened
                // Rosetta Code objects to the default Java user agent so use a blank one
                rc.setRequestProperty("User-Agent", "")
                val bfr = BufferedReader(InputStreamReader(rc.inputStream))
                try {
                    gcm = ""
                    var languageName = "?"
                    var line: String? = bfr.readLine()
                    while (line != null) {
                        line = line.trim { it <= ' ' }
                        if (line.startsWith("[title]")) {
                            // have a programming language - should look like "[title] => Category:languageName"
                            languageName = line[':']
                        } else if (line.startsWith("[pages]")) {
                            // number of pages the language has (probably)
                            val pageCount = line['>']
                            if (pageCount != "Array") {
                                // haven't got "[pages] => Array" - must be a number of pages
                                languages += pageCount.toInt().toChar() + languageName
                                languageName = "?"
                            }
                        } else if (line.startsWith("[gcmcontinue]"))
                            gcm = line['>']  // have an indication of whether there is more data or not
                        line = bfr.readLine()
                    }
                } finally {
                    bfr.close()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        } while (gcm != "")

        return languages.sortedWith(LanguageComparator)
    }

    /** Custom sort Comparator for sorting the language list.
     * Assumes the first character is the page count and the rest is the language name. */
    internal object LanguageComparator : java.util.Comparator<String> {
        override fun compare(a: String, b: String): Int {
            // as we "know" we will be comparing languages, we will assume the Strings have the appropriate format
            var r = b.first() - a.first()
            return if (r == 0) a.compareTo(b) else r
            // r == 0: the counts are the same - compare the names
        }
    }

    /** Gets the string following marker in text. */
    private operator fun String.get(c: Char) = substringAfter(c).trim { it <= ' ' }

    private val url = "http://www.rosettacode.org/mw/api.php?action=query" +
            "&generator=categorymembers" + "&gcmtitle=Category:Programming%20Languages" +
            "&gcmlimit=500"
}

fun main(args: Array<String>) {
    // read/sort/print the languages (CSV format):
    var lastTie = -1
    var lastCount = -1
    Popularity.ofLanguages().forEachIndexed { i, lang ->
        val count = lang.first().toInt()
        if (count == lastCount)
            println("%12s%s".format("", lang.substring(1)))
        else {
            println("%4d, %4d, %s".format(1 + if (count == lastCount) lastTie else i, count, lang.substring(1)))
            lastTie = i
            lastCount = count
        }
    }
}
