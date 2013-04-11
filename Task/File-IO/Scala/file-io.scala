import java.nio.file._

val input = Paths.get("input.txt")
val output = Paths.get("output.txt")

Files.copy(input, output)
