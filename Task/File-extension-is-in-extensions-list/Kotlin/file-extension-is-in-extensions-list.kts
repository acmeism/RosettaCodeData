// version 1.1

/* implicitly allows for extensions containing dots */
fun String.isFileExtensionListed(extensions: List<String>): Boolean {
    return extensions.any { toLowerCase().endsWith("." + it.toLowerCase()) }
}

fun main(args: Array<String>) {
    val extensions = listOf("zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2")
    val fileNames  = listOf(
        "MyData.a##",
        "MyData.tar.Gz",
        "MyData.gzip",
        "MyData.7z.backup",
        "MyData...",
        "MyData",
        "MyData_v1.0.tar.bz2",
        "MyData_v1.0.bz2"
    )

    for (fileName in fileNames) {
        println("${fileName.padEnd(19)} -> ${fileName.isFileExtensionListed(extensions)}")
    }
}
