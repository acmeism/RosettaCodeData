// version 1.0.6

fun main(args: Array<String>) {
    val input = "a!===b=!=c"
    val delimiters = arrayOf("==", "!=", "=")
    val output = input.split(*delimiters).toMutableList()
    for (i in 0 until output.size) {
        if (output[i].isEmpty()) output[i] = "empty string"
        else output[i] = "\"" + output[i] + "\""
    }
    println("The splits are:")
    println(output)

    // now find positions of matched delimiters
    val matches = mutableListOf<Pair<String, Int>>()
    var index = 0
    while (index < input.length) {
        var matched = false
        for (d in delimiters) {
            if (input.drop(index).take(d.length) == d) {
                matches.add(d to index)
                index += d.length
                matched = true
                break
            }
        }
        if (!matched) index++
    }
    println("\nThe delimiters matched and the indices at which they occur are:")
    println(matches)
}
