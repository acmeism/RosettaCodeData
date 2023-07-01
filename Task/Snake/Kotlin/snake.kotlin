// Kotlin Native v0.5

import kotlinx.cinterop.*
import platform.posix.*
import platform.windows.*

const val WID = 60
const val HEI = 30
const val MAX_LEN = 600
const val NUL = '\u0000'

enum class Dir { NORTH, EAST, SOUTH, WEST }

class Snake {
    val console: HANDLE
    var alive = false
    val brd = CharArray(WID * HEI)
    var dir = Dir.NORTH
    val snk = nativeHeap.allocArray<COORD>(MAX_LEN)
    lateinit var head: COORD
    var tailIdx = 0
    var headIdx = 0
    var points = 0

    init {
        console = GetStdHandle(STD_OUTPUT_HANDLE)!!
        SetConsoleTitleW("Snake")
        memScoped {
            val coord = alloc<COORD>().apply { X = (WID + 1).toShort(); Y = (HEI + 2).toShort() }
            SetConsoleScreenBufferSize(console, coord.readValue())
            val rc = alloc<SMALL_RECT>().apply {
                Left = 0; Top = 0; Right = WID.toShort(); Bottom = (HEI + 1).toShort()
            }
            SetConsoleWindowInfo(console, TRUE, rc.ptr)
            val ci = alloc<CONSOLE_CURSOR_INFO>().apply { dwSize = 1; bVisible = FALSE }
            SetConsoleCursorInfo(console, ci.ptr)
        }
    }

    fun play() {
        while (true) {
            createfield()
            alive = true
            while (alive) {
                drawfield()
                readKey()
                moveSnake()
                Sleep(50)
            }
            memScoped {
                val c = alloc<COORD>().apply { X = 0; Y = (HEI + 1).toShort() }
                SetConsoleCursorPosition(console, c.readValue())
            }
            SetConsoleTextAttribute(console, 0x000b)
            print("Play again [Y/N]? ")
            val a = readLine()!!.toLowerCase()
            if (a.length > 0 && a[0] != 'y') {
                nativeHeap.free(snk)
                return
            }
        }
    }

    private fun createfield() {
        memScoped {
            val coord = alloc<COORD>().apply { X = 0; Y = 0 }
            val c = alloc<DWORDVar>()
            FillConsoleOutputCharacterW(console, 32, (HEI + 2) * 80, coord.readValue(), c.ptr)
            FillConsoleOutputAttribute(console, 0x0000, (HEI + 2) * 80, coord.readValue(), c.ptr)
            SetConsoleCursorPosition(console, coord.readValue())
        }
        for (x in 0 until WID * HEI) brd[x] = NUL
        for (x in 0 until WID) {
            brd[x + WID * (HEI - 1)] = '+'
            brd[x] = '+'
        }
        for (y in 1 until HEI) {
            brd[WID - 1 + WID * y] = '+'
            brd[WID * y] = '+'
        }
        var xx: Int
        var yy: Int
        do {
            xx = rand() % WID
            yy = rand() % (HEI shr 1) + (HEI shr 1)
        }
        while (brd[xx + WID * yy] != NUL)
        brd[xx + WID * yy] = '@'
        tailIdx = 0
        headIdx = 4
        xx = 3
        yy = 2
        for (cc in tailIdx until headIdx) {
            brd[xx + WID * yy] = '#'
            snk[cc].X = (3 + cc).toShort()
            snk[cc].Y = 2
        }
        head = snk[3]
        dir = Dir.EAST
        points = 0
    }

    private fun readKey() {
        if ((GetAsyncKeyState(39).toInt() and 0x8000) != 0) dir = Dir.EAST
        if ((GetAsyncKeyState(37).toInt() and 0x8000) != 0) dir = Dir.WEST
        if ((GetAsyncKeyState(38).toInt() and 0x8000) != 0) dir = Dir.NORTH
        if ((GetAsyncKeyState(40).toInt() and 0x8000) != 0) dir = Dir.SOUTH
    }

    private fun drawfield() {
        memScoped {
            val coord = alloc<COORD>()
            var t = NUL
            for (y in 0 until HEI) {
                coord.Y = y.toShort()
                for (x in 0 until WID) {
                    t = brd[x + WID * y]
                    if (t == NUL) continue
                    coord.X = x.toShort()
                    SetConsoleCursorPosition(console, coord.readValue())
                    if (coord.X == head.X && coord.Y == head.Y) {
                        SetConsoleTextAttribute(console, 0x002e)
                        print('O')
                        SetConsoleTextAttribute(console, 0x0000)
                        continue
                    }
                    when (t) {
                        '#' ->  SetConsoleTextAttribute(console, 0x002a)
                        '+' ->  SetConsoleTextAttribute(console, 0x0019)
                        '@' ->  SetConsoleTextAttribute(console, 0x004c)
                    }
                    print(t)
                    SetConsoleTextAttribute(console, 0x0000)
                }
            }
            print(t)
            SetConsoleTextAttribute(console, 0x0007)
            val c = alloc<COORD>().apply { X = 0; Y = HEI.toShort() }
            SetConsoleCursorPosition(console, c.readValue())
            print("Points: $points")
        }
    }

    private fun moveSnake() {
        when (dir) {
            Dir.NORTH -> head.Y--
            Dir.EAST  -> head.X++
            Dir.SOUTH -> head.Y++
            Dir.WEST  -> head.X--
        }
        val t = brd[head.X + WID * head.Y]
        if (t != NUL && t != '@') {
            alive = false
            return
        }
        brd[head.X + WID * head.Y] = '#'
        snk[headIdx].X = head.X
        snk[headIdx].Y = head.Y
        if (++headIdx >= MAX_LEN) headIdx = 0
        if (t == '@') {
            points++
            var x: Int
            var y: Int
            do {
                x = rand() % WID
                y = rand() % (HEI shr 1) + (HEI shr 1)
            }
            while (brd[x + WID * y] != NUL)
            brd[x + WID * y] = '@'
            return
        }
        SetConsoleCursorPosition(console, snk[tailIdx].readValue())
        print(' ')
        brd[snk[tailIdx].X + WID * snk[tailIdx].Y] = NUL
        if (++tailIdx >= MAX_LEN) tailIdx = 0
    }
}

fun main(args: Array<String>) {
    srand(time(null).toInt())
    Snake().play()
}
