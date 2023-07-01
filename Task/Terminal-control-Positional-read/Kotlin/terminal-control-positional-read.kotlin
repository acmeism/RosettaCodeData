// Kotlin Native version 0.3

import kotlinx.cinterop.*
import win32.*

fun main(args: Array<String>) {
    for (i in 0 until (80 * 25)) print("A")  // fill 80 x 25 console with 'A's
    println()
    memScoped {
        val conOut = GetStdHandle(-11)
        val info = alloc<CONSOLE_SCREEN_BUFFER_INFO>()
        val pos = alloc<COORD>()
        GetConsoleScreenBufferInfo(conOut, info.ptr)
        pos.X = (info.srWindow.Left + 3).toShort()  // column number 3 of display window
        pos.Y = (info.srWindow.Top + 6).toShort()   // row number 6 of display window
        val c = alloc<wchar_tVar>()
        val len = alloc<IntVar>()
        ReadConsoleOutputCharacterW(conOut, c.ptr, 1, pos.readValue(), len.ptr)
        if (len.value == 1) {
            val ch = c.value.toChar()
            println("The character at column 3, row 6 is '$ch'")
        }
        else println("Something went wrong!")
    }
}
