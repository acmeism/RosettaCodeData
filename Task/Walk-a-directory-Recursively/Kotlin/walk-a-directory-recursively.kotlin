// version 1.2.0

import java.io.File

fun walkDirectoryRecursively(dirPath: String, pattern: Regex): Sequence<String> {
    val d = File(dirPath)
    require (d.exists() && d.isDirectory())
    return d.walk().map { it.name }.filter { it.matches(pattern) }.sorted().distinct() }

fun main(args: Array<String>) {
    val r = Regex("""^v(a|f).*\.h$""")  // get all C header files beginning with 'va' or 'vf'
    val files = walkDirectoryRecursively("/usr/include", r)
    for (file in files) println(file)
}
