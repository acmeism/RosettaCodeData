// version 1.0.6

object Gray {
    fun encode(n: Int) = n xor (n shr 1)

    fun decode(n: Int): Int {
        var p  = n
        var nn = n
        while (nn != 0) {
            nn = nn shr 1
            p = p xor nn
        }
        return p
    }
}

fun main(args: Array<String>) {
    println("Number\tBinary\tGray\tDecoded")
    for (i in 0..31) {
        print("$i\t${Integer.toBinaryString(i)}\t")
        val g = Gray.encode(i)
        println("${Integer.toBinaryString(g)}\t${Gray.decode(g)}")
    }
}
