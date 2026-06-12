// version 1.0.6

val r = Regex("[^a-zA-Z0-9]") // matches any non-alphanumeric character

fun extractFileExtension(path: String): String {
    if (path.isEmpty()) return ""
    var fileName = path.substringAfterLast('/')
    if (path == fileName) fileName = path.substringAfterLast('\\')
    val splits = fileName.split('.')
    if (splits.size == 1) return ""
    val ext = splits.last()
    return if (r.containsMatchIn(ext)) "" else "." + ext
}

fun main(args: Array<String>) {
    val paths = arrayOf(
        "http://example.com/download.tar.gz",
        "CharacterModel.3DS",
        ".desktop",
        "document",
        "document.txt_backup",
        "/etc/pam.d/login",
        "c:\\programs\\myprogs\\myprog.exe",          // using back-slash as delimiter
        "c:\\programs\\myprogs\\myprog.exe_backup"    // ditto
    )
    for (path in paths) {
        val ext =  extractFileExtension(path)
        println("${path.padEnd(37)} -> ${if (ext.isEmpty()) "(empty string)" else ext}")
    }
}
