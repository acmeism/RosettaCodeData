// version 1.1.51

val conditions = listOf(
    "Printer prints"                    to "NNNNYYYY",
    "A red light is flashing"           to "YYNNYYNN",
    "Printer is recognized by computer" to "NYNYNYNY"
)

val actions = listOf(
    "Check the power cable"                to "NNYNNNNN",
    "Check the printer-computer cable"     to "YNYNNNNN",
    "Ensure printer software is installed" to "YNYNYNYN",
    "Check/replace ink"                    to "YYNNNYNN",
    "Check for paper jam"                  to "NYNYNNNN"
)

fun main(args: Array<String>) {
    val nc = conditions.size
    val na = actions.size
    val nr = conditions[0].second.length  // number of rules
    val np = 7  // index of 'no problem' rule
    println("Please answer the following questions with a y or n:")
    val answers = BooleanArray(nc)
    for (c in 0 until nc) {
        var input: String
        do {
            print("  ${conditions[c].first} ? ")
            input = readLine()!!.toUpperCase()
        }
        while (input != "Y" && input != "N")
        answers[c] = (input == "Y")
    }
    println("\nRecommended action(s):")
    outer@ for (r in 0 until nr) {
        for (c in 0 until nc) {
            val yn = if (answers[c]) 'Y' else 'N'
            if (conditions[c].second[r] != yn) continue@outer
        }
        if (r == np) {
            println("  None (no problem detected)")
        }
        else {
            for (a in 0 until na) {
                if (actions[a].second[r] == 'Y') println("  ${actions[a].first}")
            }
        }
        return
    }
}
