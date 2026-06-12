// Kotlin Native v0.5

import kotlinx.cinterop.*
import platform.windows.*
import platform.posix.*

val ascii = 32..126
val conOut = GetStdHandle(STD_OUTPUT_HANDLE)!!

fun setCursor(p: COORD) = SetConsoleCursorPosition(conOut, p.readValue())

fun getInput(row: Short, col: Short, width: Int): String {
    require(row in 0..20 && col in 0..(79 - width) && width in 1..78) { "Invalid parameter(s)" }
    memScoped {
        val coord = alloc<COORD>().apply { X = col; Y = row }
        setCursor(coord)
    }
    val sb = StringBuilder(width)
    var full = false
    loop@ while (true) {
        val ch = _getwch()                                                   // gets next character, no echo
        when (ch.toInt()) {
                3, 13 -> break@loop                                          // break on Ctrl-C or enter key
                    8 -> if (sb.length > 0) { print("\b \b"); sb.length-- }  // mimic backspace
               0, 224 -> _getwch()                                           // consume extra character
             in ascii -> if (!full) { _putwch(ch); sb.append(ch.toChar()) }  // echo ascii character
                 else -> {}                                                  // igore other characters
        }
        full = sb.length == width                                            // can't exceed width
    }
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
