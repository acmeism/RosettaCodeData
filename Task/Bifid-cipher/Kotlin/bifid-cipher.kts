import kotlin.math.sqrt

data class Square(private val square: String) {
    private val dim: Int =
        sqrt(square.length.toDouble()).toInt()
    fun encode(ch: Char): Pair<Int, Int> =
        square.indexOf(ch).let { idx -> Pair(idx / dim, idx.mod(dim)) }
    fun decode(pair: List<Int>): Char =
        square[pair[0] * dim + pair[1]]
    fun decode(row: Int, col: Int): Char =
        square[row * dim + col]
}

class Bifid(private val square: Square) {
    fun encrypt(str: String): String {
        fun expandAndScatter(str: String): IntArray {
            val buffer = IntArray(str.length * 2)
            str.forEachIndexed { i, ch ->
                with(square.encode(ch)) {
                    buffer[i] = first
                    buffer[str.length + i] = second
                }
            }
            return buffer
        }

        val buffer = expandAndScatter(str)

        val characters: List<Char> = buffer.asIterable()
            .windowed(size = 2, step = 2)
            .map { square.decode(it) }

        return String(characters.toCharArray())
    }

    fun decrypt(str: String): String {
        fun expand(str: String): IntArray {
            val buffer = IntArray(str.length * 2)
            for (i in buffer.indices step 2) {
                with(square.encode(str[i / 2])) {
                    buffer[i] = first
                    buffer[1 + i] = second
                }
            }
            return buffer
        }

        val buffer = expand(str)

        val characters = str.toCharArray()
        for (i in characters.indices) {
            characters[i] = square.decode(buffer[i], buffer[characters.size + i])
        }
        return String(characters)
    }
}

fun main() {
    with (Bifid(Square("ABCDEFGHIKLMNOPQRSTUVWXYZ"))) {
        println("\n### ABC... 5x5")
        encrypt("ATTACKATDAWN").also { println("ATTACKATDAWN -> $it") }
        decrypt("DQBDAXDQPDQH").also { println("DQBDAXDQPDQH -> $it") }
    }
    with(Bifid(Square("BGWKZQPNDSIOAXEFCLUMTHYVR"))) {
        println("\n### BGW... 5x5")
        encrypt("FLEEATONCE").also { println("FLEEATONCE -> $it") }
        decrypt("UAEOLWRINS").also { println("UAEOLWRINS -> $it") }

        encrypt("ATTACKATDAWN").also { println("ATTACKATDAWN -> $it") }
        decrypt("EYFENGIWDILA").also { println("EYFENGIWDILA -> $it") }
    }
    with(Bifid(Square("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"))) {
        println("\n### ABC... 6x6")
        encrypt("THEINVASIONWILLSTARTONTHEFIRSTOFJANUARY").also { println("$it") }
        decrypt("TBPDIPHJSPOTAIVMGPCZKNSCN09BFIHK64I7BM4").also { println("$it") }
    }
}
