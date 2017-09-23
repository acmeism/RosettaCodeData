// version 1.1.2

fun main(args: Array<String>) {
    println("Please enter a multi-line story template terminated by a blank line\n")
    val sb  = StringBuilder()
    while (true) {
        val line = readLine()!!
        if (line.isEmpty()) break
        sb.append("$line\n") // preserve line breaks
    }
    var story = sb.toString()
    // identify blanks
    val r = Regex("<.*?>")
    val blanks = r.findAll(story).map { it.value }.distinct()
    println("Please enter your replacements for the following 'blanks' in the story:")
    for (blank in blanks) {
        print("${blank.drop(1).dropLast(1)} : ")
        val repl = readLine()!!
        story = story.replace(blank, repl)
    }
    println("\n$story")
}
