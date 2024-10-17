import java.io.StringWriter

class Cistercian() {
    constructor(number: Int) : this() {
        draw(number)
    }

    private val size = 15
    private var canvas = Array(size) { Array(size) { ' ' } }

    init {
        initN()
    }

    private fun initN() {
        for (row in canvas) {
            row.fill(' ')
            row[5] = 'x'
        }
    }

    private fun horizontal(c1: Int, c2: Int, r: Int) {
        for (c in c1..c2) {
            canvas[r][c] = 'x'
        }
    }

    private fun vertical(r1: Int, r2: Int, c: Int) {
        for (r in r1..r2) {
            canvas[r][c] = 'x'
        }
    }

    private fun diagd(c1: Int, c2: Int, r: Int) {
        for (c in c1..c2) {
            canvas[r + c - c1][c] = 'x'
        }
    }

    private fun diagu(c1: Int, c2: Int, r: Int) {
        for (c in c1..c2) {
            canvas[r - c + c1][c] = 'x'
        }
    }

    private fun drawPart(v: Int) {
        when (v) {
            1 -> {
                horizontal(6, 10, 0)
            }
            2 -> {
                horizontal(6, 10, 4)
            }
            3 -> {
                diagd(6, 10, 0)
            }
            4 -> {
                diagu(6, 10, 4)
            }
            5 -> {
                drawPart(1)
                drawPart(4)
            }
            6 -> {
                vertical(0, 4, 10)
            }
            7 -> {
                drawPart(1)
                drawPart(6)
            }
            8 -> {
                drawPart(2)
                drawPart(6)
            }
            9 -> {
                drawPart(1)
                drawPart(8)
            }

            10 -> {
                horizontal(0, 4, 0)
            }
            20 -> {
                horizontal(0, 4, 4)
            }
            30 -> {
                diagu(0, 4, 4)
            }
            40 -> {
                diagd(0, 4, 0)
            }
            50 -> {
                drawPart(10)
                drawPart(40)
            }
            60 -> {
                vertical(0, 4, 0)
            }
            70 -> {
                drawPart(10)
                drawPart(60)
            }
            80 -> {
                drawPart(20)
                drawPart(60)
            }
            90 -> {
                drawPart(10)
                drawPart(80)
            }

            100 -> {
                horizontal(6, 10, 14)
            }
            200 -> {
                horizontal(6, 10, 10)
            }
            300 -> {
                diagu(6, 10, 14)
            }
            400 -> {
                diagd(6, 10, 10)
            }
            500 -> {
                drawPart(100)
                drawPart(400)
            }
            600 -> {
                vertical(10, 14, 10)
            }
            700 -> {
                drawPart(100)
                drawPart(600)
            }
            800 -> {
                drawPart(200)
                drawPart(600)
            }
            900 -> {
                drawPart(100)
                drawPart(800)
            }

            1000 -> {
                horizontal(0, 4, 14)
            }
            2000 -> {
                horizontal(0, 4, 10)
            }
            3000 -> {
                diagd(0, 4, 10)
            }
            4000 -> {
                diagu(0, 4, 14)
            }
            5000 -> {
                drawPart(1000)
                drawPart(4000)
            }
            6000 -> {
                vertical(10, 14, 0)
            }
            7000 -> {
                drawPart(1000)
                drawPart(6000)
            }
            8000 -> {
                drawPart(2000)
                drawPart(6000)
            }
            9000 -> {
                drawPart(1000)
                drawPart(8000)
            }
        }
    }

    private fun draw(v: Int) {
        var v2 = v

        val thousands = v2 / 1000
        v2 %= 1000

        val hundreds = v2 / 100
        v2 %= 100

        val tens = v2 / 10
        val ones = v % 10

        if (thousands > 0) {
            drawPart(1000 * thousands)
        }
        if (hundreds > 0) {
            drawPart(100 * hundreds)
        }
        if (tens > 0) {
            drawPart(10 * tens)
        }
        if (ones > 0) {
            drawPart(ones)
        }
    }

    override fun toString(): String {
        val sw = StringWriter()
        for (row in canvas) {
            for (cell in row) {
                sw.append(cell)
            }
            sw.appendLine()
        }
        return sw.toString()
    }
}

fun main() {
    for (number in arrayOf(0, 1, 20, 300, 4000, 5555, 6789, 9999)) {
        println("$number:")

        val c = Cistercian(number)
        println(c)
    }

}
