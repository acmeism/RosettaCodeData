// version 1.1.3

import java.io.File
import java.io.BufferedReader
import java.io.InputStreamReader

fun main(args: Array<String>) {
    val keywords = listOf(
        "import", "internal", "fun", "if", "throw", "val", "var", "for", "in", "while"
    )

    val singleCase = listOf(
        "java.text",
        "java.util",
        "java.io",
        "else",     // really a keyword but doesn't have a following space here
        "ceil",
        "it",       // really a keyword but doesn't have a following space here
        "get(",     // also included in GETACTUALMAXIMUM
        "slice",
        "map",
        "months",
        "length",
        ".format",  // also variable called FORMAT
        "add",
        "printf",
        "println",
        "out",
        "main",
        "args",
        "s%{1}s",
        "%2s",
        "s%n%n",
        "s%n",
        "%s"
    )

    val mixedCase = listOf(
        "PRINTSTREAM" to "PrintStream",
        "INT," to "Int,",  // also included in PRINTCALENDAR
        "BYTE" to "Byte",
        "LOCALE?" to "Locale?",  // also variable called LOCALE
        "LOCALE." to "Locale.",
        "ILLEGALARGUMENTEXCEPTION" to "IllegalArgumentException",
        "MATH" to "Math",
        "GREGORIANCALENDAR" to "GregorianCalendar",
        "DATEFORMATSYMBOLS" to "DateFormatSymbols",
        "ARRAY" to "Array",
        "MESSAGEFORMAT" to "MessageFormat",
        "JOINTOSTRING" to "joinToString",
        "STRING" to "String",
        "CALENDAR." to "Calendar.", // also included in PRINTCALENDAR
        "SYSTEM" to "System",
        "TOINT" to "toInt",
        "SHORTWEEKDAYS" to "shortWeekdays",
        "FOREACHINDEXED" to "forEachIndexed",
        "GETACTUALMAXIMUM" to "getActualMaximum",
        "TOUPPERCASE" to "toUpperCase"
    )

    var text = File("calendar_UC.txt").readText()
    for (k in keywords)   text = text.replace("${k.toUpperCase()} ", "$k ") // add a following space to be on safe side
    for (s in singleCase) text = text.replace(s.toUpperCase(), s)
    for (m in mixedCase)  text = text.replace(m.first, m.second)
    File("calendar_NC.kt").writeText(text)
    val commands = listOf("kotlinc", "calendar_NC.kt", "-include-runtime", "-d", "calendar_X.jar")
    val pb = ProcessBuilder(commands)
    pb.redirectErrorStream(true)
    val process = pb.start()
    process.waitFor()
    val commands2 = listOf("java", "-jar", "calendar_NC.jar")
    val pb2 = ProcessBuilder(commands2)
    pb2.redirectErrorStream(true)
    val process2 = pb2.start()
    val out = StringBuilder()
    val br = BufferedReader(InputStreamReader(process2.inputStream))
    while (true) {
        val line = br.readLine()
        if (line == null) break
        out.append(line).append('\n')
    }
    br.close()
    println(out.toString())
}
