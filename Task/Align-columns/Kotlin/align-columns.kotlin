import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Paths

enum class AlignFunction {
    LEFT { override fun invoke(s: String, l: Int) = ("%-" + l + 's').format(("%" + s.length + 's').format(s)) },
    RIGHT { override fun invoke(s: String, l: Int) = ("%-" + l + 's').format(("%" + l + 's').format(s)) },
    CENTER { override fun invoke(s: String, l: Int) = ("%-" + l + 's').format(("%" + ((l + s.length) / 2) + 's').format(s)) };

    abstract operator fun invoke(s: String, l: Int): String
}

/** Aligns fields into columns, separated by "|".
 * @constructor Initializes columns aligner from lines in a list of strings.
 * @property lines Lines in a single string. Empty string does form a column.
 */
class ColumnAligner(val lines: List<String>) {
     operator fun invoke(a: AlignFunction) : String {
        var result = ""
        for (lineWords in words) {
            for (i in lineWords.indices) {
                if (i == 0)
                    result += '|'
                result += a(lineWords[i], column_widths[i])
                result += '|'
            }
            result += '\n'
        }
        return result
    }

    private val words = arrayListOf<Array<String>>()
    private val column_widths = arrayListOf<Int>()

    init {
        lines.forEach  {
            val lineWords = java.lang.String(it).split("\\$")
            words += lineWords
            for (i in lineWords.indices) {
                if (i >= column_widths.size) {
                    column_widths += lineWords[i].length
                } else {
                    column_widths[i] = Math.max(column_widths[i], lineWords[i].length)
                }
            }
        }
    }
}

fun main(args: Array<String>) {
    if (args.isEmpty()) {
        println("Usage: ColumnAligner file [L|R|C]")
        return
    }
    val ca = ColumnAligner(Files.readAllLines(Paths.get(args[0]), StandardCharsets.UTF_8))
    val alignment = if (args.size >= 2) args[1] else "L"
    when (alignment) {
        "L" -> print(ca(AlignFunction.LEFT))
        "R" -> print(ca(AlignFunction.RIGHT))
        "C" -> print(ca(AlignFunction.CENTER))
        else -> System.err.println("Error! Unknown alignment: " + alignment)
    }
}
