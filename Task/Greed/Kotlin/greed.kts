// Kotlin Native v0.5

import kotlinx.cinterop.*
import platform.posix.*
import platform.windows.*

const val WID = 79
const val HEI = 22
const val NCOUNT = (WID * HEI).toFloat()

class WinConsole {
    val conOut: HANDLE
    val conIn: HANDLE

    private constructor() {
        conOut = GetStdHandle(STD_OUTPUT_HANDLE)!!
        conIn  = GetStdHandle(STD_INPUT_HANDLE)!!
        showCursor(FALSE)
    }

    fun showCursor(s: WINBOOL) {
        memScoped {
            val ci = alloc<CONSOLE_CURSOR_INFO>().apply { dwSize = 1; bVisible = s }
            SetConsoleCursorInfo(conOut, ci.ptr)
        }
    }

    fun setColor(clr: WORD) = SetConsoleTextAttribute(conOut, clr)

    fun setCursor(p: COORD) = SetConsoleCursorPosition(conOut, p.readValue())

    fun flush() =  FlushConsoleInputBuffer(conIn)

    fun kill() {
        inst = null
    }

    companion object {
        val instance: WinConsole
            get() {
                if (inst == null) inst = WinConsole()
                return inst!!
            }

        private var inst: WinConsole? = null
    }
}

class Greed {
    private val console: WinConsole
    private val brd = IntArray(WID * HEI)
    private var score = 0
    private lateinit var cursor: COORD

    init {
        console = WinConsole.instance
        SetConsoleTitleW("Greed")
    }

    fun destroy() {
        nativeHeap.free(cursor)
        console.kill()
    }

    fun play() {
        memScoped {
            val coord1 = alloc<COORD>().apply { X = 0;  Y = 24 }
            val coord2 = alloc<COORD>().apply { X = 19; Y = 8  }
            val coord3 = alloc<COORD>().apply { X = 19; Y = 9  }
            val coord4 = alloc<COORD>().apply { X = 19; Y = 10  }
            val coord5 = alloc<COORD>().apply { X = 19; Y = 11  }
            val coord6 = alloc<COORD>().apply { X = 48; Y = 10  }
            do {
                console.showCursor(FALSE)
                createBoard()
                do {
                    displayBoard()
                    getInput()
                }
                while (existsMoves())
                displayBoard()
                with (console) {
                    setCursor(coord1)
                    setColor(0x07)
                    setCursor(coord2);  print("+----------------------------------------+")
                    setCursor(coord3);  print("|               GAME OVER                |")
                    setCursor(coord4);  print("|            PLAY AGAIN(Y/N)?            |")
                    setCursor(coord5);  print("+----------------------------------------+")
                    setCursor(coord6)
                    showCursor(TRUE)
                    flush()
                }
                val g = readLine()!!.toUpperCase()
            }
            while (g.length >= 1 && g[0] == 'Y')
        }
        destroy()
    }

    private fun createBoard() {
        for (y in 0 until HEI) {
            for (x in 0 until WID) {
                brd[x + WID * y] = rand() % 9 + 1
            }
        }
        cursor = nativeHeap.alloc<COORD>().apply {
            X = (rand() % WID).toShort(); Y = (rand() % HEI).toShort()
        }
        brd[cursor.X + WID * cursor.Y] = 0
        score = 0
        printScore()
    }

    private fun displayBoard() {
        memScoped {
            val coord = alloc<COORD>().apply { X = 0; Y = 0 }
            console.setCursor(coord)
        }
        for (y in 0 until HEI) {
            for (x in 0 until WID) {
                val i = brd[x + WID * y]
                console.setColor((6 + i).toShort())
                print(if (i == 0) " " else "$i")
            }
            println()
        }
        console.setColor(15)
        console.setCursor(cursor)
        print("@")
    }

    private fun checkKey(k: Char) = (GetAsyncKeyState(k.toInt()).toInt() and 0x8000) != 0

    private fun getInput() {
        while (true) {
            if (checkKey('Q') && cursor.X > 0 && cursor.Y > 0) { execute(-1, -1); break }
            if (checkKey('W') && cursor.Y > 0) { execute(0, -1); break }
            if (checkKey('E') && cursor.X < WID - 1 && cursor.Y > 0) { execute(1, -1); break }
            if (checkKey('A') && cursor.X > 0) { execute(-1, 0); break }
            if (checkKey('D') && cursor.X < WID - 1) { execute(1, 0); break }
            if (checkKey('Z') && cursor.X > 0 && cursor.Y < HEI - 1) { execute(-1, 1); break }
            if (checkKey('X') && cursor.Y < HEI - 1) { execute(0, 1); break }
            if (checkKey('C') && cursor.X < WID - 1 && cursor.Y < HEI - 1) { execute(1, 1); break }
        }
        console.flush()
        printScore()
    }

    private fun printScore() {
        memScoped {
            val coord = alloc<COORD>().apply { X = 0; Y = 24 }
            console.setCursor(coord)
        }
        console.setColor(0x2a)
        print("      SCORE: $score :  ${score * 100.0f / NCOUNT}%      ")
    }

    private fun execute(x: Int, y: Int) {
        var i = brd[cursor.X + x + WID * ( cursor.Y + y )]
        if (countSteps(i, x, y)) {
            score += i
            while (i-- != 0) {
                cursor.X = (cursor.X + x).toShort()
                cursor.Y = (cursor.Y + y).toShort()
                brd[cursor.X + WID * cursor.Y] = 0
            }
        }
    }

    private fun countSteps(i: Int, x: Int, y: Int): Boolean {
        var ii = i
        memScoped {
            val t = alloc<COORD>().apply { X = cursor.X; Y = cursor.Y }
            while (ii-- != 0) {
                t.X = (t.X + x).toShort()
                t.Y = (t.Y + y).toShort()
                if (t.X < 0 || t.Y < 0 || t.X >= WID || t.Y >= HEI || brd[t.X + WID * t.Y] == 0 ) return false
            }
        }
        return true
    }

    private fun existsMoves(): Boolean {
        for (y in -1..1) {
            for (x in -1..1) {
                if (x == 0 && y == 0) continue
                val i = brd[cursor.X + x + WID * ( cursor.Y + y )]
                if (i > 0 && countSteps(i, x, y)) return true
            }
        }
        return false
    }
}

fun main(args: Array<String>) {
    srand(time(null).toInt())
    Greed().play()
}
