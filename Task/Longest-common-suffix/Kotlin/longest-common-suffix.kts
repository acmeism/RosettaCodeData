fun lcs(a: List<String>): String {
    val le = a.size
    if (le == 0) {
        return ""
    }
    if (le == 1) {
        return a[0]
    }
    val le0 = a[0].length
    var minLen = le0
    for (i in 1 until le) {
        if (a[i].length < minLen) {
            minLen = a[i].length
        }
    }
    if (minLen == 0) {
        return ""
    }
    var res = ""
    val a1 = a.subList(1, a.size)
    for (i in 1..minLen) {
        val suffix = a[0].substring(le0 - i)
        for (e in a1) {
            if (!e.endsWith(suffix)) {
                return res
            }
        }
        res = suffix
    }
    return ""
}

fun main() {
    val tests = listOf(
        listOf("baabababc", "baabc", "bbbabc"),
        listOf("baabababc", "baabc", "bbbazc"),
        listOf("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"),
        listOf("longest", "common", "suffix"),
        listOf("suffix"),
        listOf("")
    )
    for (test in tests) {
        println("$test -> `${lcs(test)}`")
    }
}
