// version 1.2.0

import java.net.URL

val rx = Regex("""<div class=\"yst result\">.+?<a href=\"(.*?)\" class=\"\">(.*?)</a>.+?class="abstract ellipsis">(.*?)</p>""")

class YahooResult(var title: String, var link: String, var text: String) {

    override fun toString() = "\nTitle: $title\nLink : $link\nText : $text"
}

class YahooSearch(val query: String, val page: Int = 0) {

    private val content: String

    init {
        val yahoo = "http://search.yahoo.com/search?"
        val url = URL("${yahoo}p=$query&b=${page * 10 + 1}")
        content = url.readText()
    }

    val results: MutableList<YahooResult>
        get() {
            val list = mutableListOf<YahooResult>()
            for (mr in rx.findAll(content)) {
               val title = mr.groups[2]!!.value.replace("<b>", "").replace("</b>", "")
               val link  = mr.groups[1]!!.value
               val text  = mr.groups[3]!!.value.replace("<b>", "").replace("</b>", "")
               list.add (YahooResult(title, link, text))
            }
            return list
        }

    fun nextPage() = YahooSearch(query, page + 1)

    fun getPage(newPage: Int) = YahooSearch(query, newPage)
}

fun main(args: Array<String>) {
    for (page in 0..1) {
        val x = YahooSearch("rosettacode", page)
        println("\nPAGE ${page + 1} =>")
        for (result in x.results.take(3)) println(result)
    }
}
