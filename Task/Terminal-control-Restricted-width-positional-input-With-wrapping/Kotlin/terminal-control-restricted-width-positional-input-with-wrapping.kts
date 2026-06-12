// Kotlin Native v0.5

import kotlinx.cinterop.*
import platform.windows.*
import platform.posix.*

val ascii = 32..126
val conOut = GetStdHandle(STD_OUTPUT_HANDLE)!!

fun setCursor(p: COORD) = SetConsoleCursorPosition(conOut, p.readValue())

fun getInput(row: Short, col: Short, width: Int): String {
    require(row in 0..20 && col in 0..(79 - width) && width in 1..78) { "Invalid parameter(s)" }
    val coord = nativeHeap.alloc<COORD>().apply { X = col; Y = row }
    setCursor(coord)
    val sb = StringBuilder(width)
    var wlen = 0                                          // length of text in editing window
    var full = false
    loop@ while (true) {
        val ch = _getwch()                                // gets next character, no echo
        when (ch.toInt()) {
            3, 13 -> break@loop                           // break on Ctrl-C or enter key

            8 -> {                                        // mimic backspace
                if (wlen > 0) {
                    print("\b \b")
                    sb.length--
                    wlen--
                }
                if (sb.length > wlen) {
                    coord.apply { X = col; Y = row }
                    setCursor(coord)
                    print(sb.toString().takeLast(width))
                    wlen = width
                }
            }

            0, 224 -> _getwch()                           // consume extra character

            in ascii -> {                                 // echo ascii character
                sb.append(ch.toChar())
                if (!full) {
                    _putwch(ch)
                    wlen++
                }
                else if (sb.length > wlen) {
                    coord.apply { X = col; Y = row }
                    setCursor(coord)
                    print(sb.toString().takeLast(width))
                }
            }

            else -> {}                                    // igore other characters
        }
        full = wlen == width                              // wlen can't exceed width
    }
    nativeHeap.free(coord)
    return sb.toString()
}

fun main(args: Array<String>) {
    system("cls")  // clear the console
    val s = getInput(2, 4, 8)  // Windows console row/col numbering starts at 0
    memScoped {
        val coord = alloc<COORD>().apply { X = 0 ; Y = 22 }
        setCursor(coord)
    }
    println("You entered '$s'")
}
