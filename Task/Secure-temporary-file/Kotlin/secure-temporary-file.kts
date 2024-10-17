import kotlin.io.path.createTempFile
import kotlin.io.path.deleteExisting

fun main() {
    val tempFilePath = createTempFile("example", ".tmp")
    println("Temporary file created: $tempFilePath")
    tempFilePath.deleteExisting()
}
