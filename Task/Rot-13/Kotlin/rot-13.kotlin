import java.io.*

fun String.rot13() = map {
    when {
        it.isUpperCase() -> { val x = it + 13; if (x > 'Z') x - 26 else x }
        it.isLowerCase() -> { val x = it + 13; if (x > 'z') x - 26 else x }
        else -> it
    } }.toCharArray()

fun InputStreamReader.println() =
        try { BufferedReader(this).forEachLine { println(it.rot13()) } }
        catch (e: IOException) { e.printStackTrace() }

fun main(args: Array<String>) {
    if (args.any())
        args.forEach { FileReader(it).println() }
    else
        InputStreamReader(System.`in`).println()
}
