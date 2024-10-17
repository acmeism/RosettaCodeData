// version 1.1.3

typealias Func = () -> Unit

fun doChar(odd: Boolean, f: Func?): Boolean {
    val c = System.`in`.read()
    if (c == -1) return false // end of stream reached
    val ch = c.toChar()

    fun writeOut() {
        print(ch)
        if (f != null) f()
    }

    if (!odd) print(ch)
    if (ch.isLetter()) return doChar(odd, ::writeOut)
    if (odd) {
        if (f != null) f()
        print(ch)
    }
    return ch != '.'
}

fun main(args: Array<String>) {
    repeat(2) {
        var b = true
        while (doChar(!b, null)) b = !b
        System.`in`.read() // remove '\n' from buffer
        println("\n")
    }
}
