// version 1.2.10

import java.io.File

data class UserInput(val formFeed: Int, val lineFeed: Int, val tab: Int, val space: Int)

fun getUserInput(): List<UserInput> {
    val h = "0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 " +
            "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 33 0 50 0 46 0 54 0 76 0 47 0 84 2 28"
    return h.split(' ').chunked(4).map {
        val (ff, lf, tb, sp) = it
        UserInput(ff.toInt(), lf.toInt(), tb.toInt(), sp.toInt())
    }
}

fun decode(fileName: String, uiList: List<UserInput>) {
    val text = File(fileName).readText()

    fun decode2(ui: UserInput): Boolean {
        var f = 0
        var l = 0
        var t = 0
        var s = 0
        val (ff, lf, tb, sp) = ui
        for (c in text) {
            if (f == ff && l == lf && t == tb && s == sp) {
                if (c == '!') return false
                print(c)
                return true
            }
            when (c) {
                '\u000c' -> { f++; l = 0; t = 0; s = 0 }
                '\n'     -> { l++; t = 0; s = 0 }
                '\t'     -> { t++; s = 0 }
                else     -> { s++ }
            }
        }
        return false
    }

    for (ui in uiList) {
        if (!decode2(ui)) break
    }
    println()
}

fun main(args: Array<String>) {
    val uiList = getUserInput()
    decode("theRaven.txt", uiList)
}
