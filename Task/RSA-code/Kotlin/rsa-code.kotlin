// version 1.1.4-3

import java.math.BigInteger

fun main(args: Array<String>) {
    val n = BigInteger("9516311845790656153499716760847001433441357")
    val e = BigInteger("65537")
    val d = BigInteger("5617843187844953170308463622230283376298685")
    val c = Charsets.UTF_8
    val plainText = "Rosetta Code"
    println("PlainText : $plainText")
    val bytes = plainText.toByteArray(c)
    val plainNum = BigInteger(bytes)
    println("As number : $plainNum")
    if (plainNum > n) {
        println("Plaintext is too long")
        return
    }

    val enc = plainNum.modPow(e, n)
    println("Encoded   : $enc")

    val dec = enc.modPow(d, n)
    println("Decoded   : $dec")

    val decText = dec.toByteArray().toString(c)
    println("As text   : $decText")
}
