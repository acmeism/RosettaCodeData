fun display(numbers: List<Int>) {
    println("[${numbers.joinToString(", ")}]")
}

fun stringSearchSingle(haystack: String, needle: String): Int {
    val index = haystack.indexOf(needle)
    return if (index != -1) index else -1
}

fun stringSearch(haystack: String, needle: String): List<Int> {
    val result = mutableListOf<Int>()
    var start = 0
    var index = 0

    while (index >= 0 && start < haystack.length) {
        val haystackReduced = haystack.substring(start)
        index = stringSearchSingle(haystackReduced, needle)

        if (index >= 0) {
            result.add(start + index)
            start += index + needle.length
        }
    }

    return result
}

fun main() {
    val texts = listOf(
        "GCTAGCTCTACGAGTCTA",
        "GGCTATAATGCGTA",
        "there would have been a time for such a word",
        "needle need noodle needle",
        "DKnuthusesandprogramsanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguages",
        "Nearby farms grew an acre of alfalfa on the dairy's behalf, with bales of that alfalfa exchanged for milk."
    )

    val patterns = listOf("TCTA", "TAATAAA", "word", "needle", "and", "alfalfa")

    texts.forEachIndexed { i, text ->
        println("text${i + 1} = $text")
    }
    println()

    texts.forEachIndexed { i, text ->
        val indexes = stringSearch(text, patterns[i])
        print("Found \"${patterns[i]}\" in 'text${i + 1}' at indexes ")
        display(indexes)
    }
}
