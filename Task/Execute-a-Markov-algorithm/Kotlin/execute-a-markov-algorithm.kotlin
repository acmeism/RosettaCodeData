// version 1.1.51

import java.io.File
import java.util.regex.Pattern

/* rulesets assumed to be separated by a blank line in file */
fun readRules(path: String): List<List<String>> {
    val ls = System.lineSeparator()
    return File(path).readText().split("$ls$ls").map { it.split(ls) }
}

/* tests assumed to be on consecutive lines */
fun readTests(path: String) = File(path).readLines()

fun main(args: Array<String>) {
    val rules = readRules("markov_rules.txt")
    val tests = readTests("markov_tests.txt")
    val pattern = Pattern.compile("^([^#]*?)\\s+->\\s+(\\.?)(.*)")

    for ((i, origTest) in tests.withIndex()) {
        val captures = mutableListOf<List<String>>()
        for (rule in rules[i]) {
            val m = pattern.matcher(rule)
            if (m.find()) {
                val groups = List<String>(m.groupCount()) { m.group(it + 1) }
                captures.add(groups)
            }
        }
        var test = origTest

        do {
            val copy = test
            var redo = false
            for (c in captures) {
                test = test.replace(c[0], c[2])
                if (c[1] == ".") break
                if (test != copy) { redo = true; break }
            }
        }
        while (redo)

        println("$origTest\n$test\n")
    }
}
