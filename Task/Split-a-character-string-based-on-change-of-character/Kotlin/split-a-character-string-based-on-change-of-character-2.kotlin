fun splitOnChange(src: String): String =
    src.fold("") { acc, c ->
        if (acc.isEmpty() || acc.last() == c) "$acc$c" else "$acc, $c"
    }

fun main() {
    splitOnChange("""gHHH5YY++///\""").also { println(it)}
}
