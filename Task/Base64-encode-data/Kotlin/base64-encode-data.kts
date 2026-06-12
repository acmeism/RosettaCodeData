// version 1.1.2

import java.io.File
import java.util.Base64

fun main(args: Array<String>) {
    val path = "favicon.ico" // already downloaded to current directory
    val bytes = File(path).readBytes()
    val base64 = Base64.getEncoder().encodeToString(bytes)
    println(base64)
}
