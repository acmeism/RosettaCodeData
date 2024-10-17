// version 1.1.2

import java.io.File

fun walkDirectory(dirPath: String, pattern: Regex): List<String> {
    val d = File(dirPath)
    require(d.exists() && d.isDirectory())
    return d.list().filter { it.matches(pattern) }
}

fun main(args: Array<String>) {
    val r = Regex("""^a.*\.h$""")  // get all C header files beginning with 'a'
    val files = walkDirectory("/usr/include", r)
    for (file in files) println(file)
}
