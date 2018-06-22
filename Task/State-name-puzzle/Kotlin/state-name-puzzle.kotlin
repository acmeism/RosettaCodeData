// version 1.2.10

fun solve(states: List<String>) {
    val dict = mutableMapOf<String, String>()
    for (state in states) {
        val key = state.toLowerCase().replace(" ", "")
        if (dict[key] == null) dict.put(key, state)
    }
    val keys = dict.keys.toList()
    val solutions = mutableListOf<String>()
    val duplicates = mutableListOf<String>()
    for (i in 0 until keys.size) {
        for (j in i + 1 until keys.size) {
            val len = keys[i].length + keys[j].length
            val chars = (keys[i] + keys[j]).toCharArray()
            chars.sort()
            val combined = String(chars)
            for (k in 0 until keys.size) {
                for (l in k + 1 until keys.size) {
                    if (k == i || k == j || l == i || l == j) continue
                    val len2 = keys[k].length + keys[l].length
                    if (len2 != len) continue
                    val chars2 = (keys[k] + keys[l]).toCharArray()
                    chars2.sort()
                    val combined2 = String(chars2)
                    if (combined == combined2) {
                        val f1 = "${dict[keys[i]]} + ${dict[keys[j]]}"
                        val f2 = "${dict[keys[k]]} + ${dict[keys[l]]}"
                        val f3 = "$f1 = $f2"
                        if (f3 in duplicates) continue
                        solutions.add(f3)
                        val f4 = "$f2 = $f1"
                        duplicates.add(f4)
                    }
                }
            }
        }
    }
    solutions.sort()
    for ((i, sol) in solutions.withIndex()) {
        println("%2d  %s".format(i + 1, sol))
    }
}

fun main(args: Array<String>) {
    val states = listOf(
        "Alabama", "Alaska", "Arizona", "Arkansas",
        "California", "Colorado", "Connecticut",
        "Delaware",
        "Florida", "Georgia", "Hawaii",
        "Idaho", "Illinois", "Indiana", "Iowa",
        "Kansas", "Kentucky", "Louisiana",
        "Maine", "Maryland", "Massachusetts", "Michigan",
        "Minnesota", "Mississippi", "Missouri", "Montana",
        "Nebraska", "Nevada", "New Hampshire", "New Jersey",
        "New Mexico", "New York", "North Carolina", "North Dakota",
        "Ohio", "Oklahoma", "Oregon",
        "Pennsylvania", "Rhode Island",
        "South Carolina", "South Dakota", "Tennessee", "Texas",
        "Utah", "Vermont", "Virginia",
        "Washington", "West Virginia", "Wisconsin", "Wyoming"
    )
    println("Real states only:")
    solve(states)
    println()
    val fictitious = listOf(
        "New Kory", "Wen Kory", "York New", "Kory New", "New Kory"
    )
    println("Real and fictitious states:")
    solve(states + fictitious)
}
