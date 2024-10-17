// version 1.1.51

fun findCommonDirPath(paths: List<String>, separator: Char): String {
    if (paths.isEmpty()) return ""
    if (paths.size == 1) return paths[0]
    val splits = paths[0].split(separator)
    val n = splits.size
    val paths2 = paths.drop(1)
    var k = 0
    var common = ""
    while (true) {
        val prevCommon = common
        common += if (k == 0) splits[0] else separator + splits[k]
        if (!paths2.all { it.startsWith(common + separator) || it == common } ) return prevCommon
        if (++k == n) return common
    }
}

fun main(args: Array<String>) {
    val paths = listOf(
        "/home/user1/tmp/coverage/test",
        "/home/user1/tmp/covert/operator",
        "/home/user1/tmp/coven/members"
    )
    val pathsToPrint = paths.map { "   '$it'" }.joinToString("\n")
    println("The common directory path of:\n\n$pathsToPrint\n")
    println("is '${findCommonDirPath(paths, '/')}'")
}
