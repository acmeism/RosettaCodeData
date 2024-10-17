import java.io.File

fun main(args: Array<String>) {
    println(File("unixdict.txt").readText(charset = Charsets.UTF_8))
}
