import kotlin.io.path.Path
import kotlin.io.path.useLines

fun main() {
    Path("unixdict.txt").useLines { lines ->
        lines
            .filter { line -> line.none { it in "aiou" } }
            .filter { line -> line.count { it == 'e' } > 3 }
            .forEach(::println)
    }
}
