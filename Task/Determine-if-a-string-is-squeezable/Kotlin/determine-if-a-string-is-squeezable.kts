fun main() {
    val testStrings = arrayOf(
        "",
        "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ",
        "..1111111111111111111111111111111111111111111111111111111111111117777888",
        "I never give 'em hell, I just tell the truth, and they think it's hell. ",
        "                                                    --- Harry S Truman  ",
        "122333444455555666666777777788888888999999999",
        "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
        "headmistressship")
    val testChar = arrayOf(
        " ",
        "-",
        "7",
        ".",
        " -r",
        "5",
        "e",
        "s")
    for (testNum in testStrings.indices) {
        val s = testStrings[testNum]
        for (c in testChar[testNum].toCharArray()) {
            val result = squeeze(s, c)
            System.out.printf("use: '%c'%nold:  %2d &gt;&gt;&gt;%s&lt;&lt;&lt;%nnew:  %2d &gt;&gt;&gt;%s&lt;&lt;&lt;%n%n", c, s.length, s, result.length, result)
        }
    }
}

private fun squeeze(input: String, include: Char): String {
    val sb = StringBuilder()
    for (i in input.indices) {
        if (i == 0 || input[i - 1] != input[i] || input[i - 1] == input[i] && input[i] != include) {
            sb.append(input[i])
        }
    }
    return sb.toString()
}
