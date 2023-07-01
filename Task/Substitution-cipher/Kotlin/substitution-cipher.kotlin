// version 1.0.6

object SubstitutionCipher {
    val key = "]kYV}(!7P\$n5_0i R:?jOWtF/=-pe'AD&@r6%ZXs\"v*N[#wSl9zq2^+g;LoB`aGh{3.HIu4fbK)mU8|dMET><,Qc\\C1yxJ"

    fun encode(s: String): String {
        val sb = StringBuilder()
        for (c in s) sb.append(key[c.toInt() - 32])
        return sb.toString()
    }

    fun decode(s: String): String {
        val sb = StringBuilder()
        for (c in s) sb.append((key.indexOf(c) + 32).toChar())
        return sb.toString()
    }
}

fun main(args: Array<String>) {
    val s = "The quick brown fox jumps over the lazy dog, who barks VERY loudly!"
    val enc = SubstitutionCipher.encode(s)
    println("Encoded:  $enc")
    println("Decoded:  ${SubstitutionCipher.decode(enc)}")
}
