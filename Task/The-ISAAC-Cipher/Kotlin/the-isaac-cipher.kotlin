// version 1.1.3

/* external results */
val randrsl = IntArray(256)
var randcnt = 0

/* internal state */
val mm = IntArray(256)
var aa = 0
var bb = 0
var cc = 0

const val GOLDEN_RATIO = 0x9e3779b9.toInt()

fun isaac() {
    cc++       // cc just gets incremented once per 256 results
    bb += cc   // then combined with bb
    for (i in 0..255) {
        val x = mm[i]
        when (i % 4) {
            0 -> aa = aa xor (aa shl 13)
            1 -> aa = aa xor (aa ushr 6)
            2 -> aa = aa xor (aa shl 2)
            3 -> aa = aa xor (aa ushr 16)
        }
        aa += mm[(i + 128) % 256]
        val y = mm[(x ushr 2) % 256] + aa + bb
        mm[i] = y
        bb = mm[(y ushr 10) % 256] + x
        randrsl[i] = bb
    }
    randcnt = 0
}

/* if (flag == true), then use the contents of randrsl to initialize mm. */
fun mix(n: IntArray) {
    n[0] = n[0] xor (n[1]  shl 11); n[3] += n[0]; n[1] += n[2]
    n[1] = n[1] xor (n[2] ushr  2); n[4] += n[1]; n[2] += n[3]
    n[2] = n[2] xor (n[3]  shl  8); n[5] += n[2]; n[3] += n[4]
    n[3] = n[3] xor (n[4] ushr 16); n[6] += n[3]; n[4] += n[5]
    n[4] = n[4] xor (n[5]  shl 10); n[7] += n[4]; n[5] += n[6]
    n[5] = n[5] xor (n[6] ushr  4); n[0] += n[5]; n[6] += n[7]
    n[6] = n[6] xor (n[7]  shl  8); n[1] += n[6]; n[7] += n[0]
    n[7] = n[7] xor (n[0] ushr  9); n[2] += n[7]; n[0] += n[1]
}

fun randinit(flag: Boolean) {
    aa = 0
    bb = 0
    cc = 0
    val n = IntArray(8) { GOLDEN_RATIO }
    for (i in 0..3) mix(n)      // scramble the array

    for (i in 0..255 step 8) {  // fill in mm with messy stuff
        if (flag) {             // use all the information in the seed
           for (j in 0..7) n[j] += randrsl[i + j]
        }
        mix(n)
        for (j in 0..7) mm[i + j] = n[j]
    }

    if (flag) {
        /* do a second pass to make all of the seed affect all of mm */
        for (i in 0..255 step 8) {
            for (j in 0..7) n[j] += mm[i + j]
            mix(n)
            for (j in 0..7) mm[i + j] = n[j]
        }
    }

    isaac()       // fill in the first set of results
    randcnt = 0  // prepare to use the first set of results
}

/* As Kotlin doesn't (yet) support unsigned types, we need to use
   Long here to get a random value in the range of a UInt */
fun iRandom(): Long {
    val r = randrsl[randcnt++]
    if (randcnt > 255) {
        isaac()
        randcnt = 0
    }
    return r.toLong() and 0xFFFFFFFFL
}

/* Get a random character (as Int) in printable ASCII range */
fun iRandA() = (iRandom() % 95 + 32).toInt()

/* Seed ISAAC with a string */
fun iSeed(seed: String, flag: Boolean) {
    for (i in 0..255) mm[i] = 0
    val m = seed.length
    for (i in 0..255) {
        /* in case seed has less than 256 elements */
        randrsl[i] = if (i >= m) 0 else seed[i].toInt()
    }
    /* initialize ISAAC with seed */
    randinit(flag)
}

/* XOR cipher on random stream. Output: ASCII string */
fun vernam(msg: String) : String {
    val len = msg.length
    val v = ByteArray(len)
    for (i in 0 until len) {
        v[i] = (iRandA() xor msg[i].toInt()).toByte()
    }
    return v.toString(charset("ASCII"))
}

/* constants for Caesar */
const val MOD = 95
const val START = 32

/* cipher modes for Caesar */
enum class CipherMode {
    ENCIPHER, DECIPHER, NONE
}

/* Caesar-shift a printable character */
fun caesar(m: CipherMode, ch: Int, shift: Int, modulo: Int, start: Int): Char {
    val sh = if (m == CipherMode.DECIPHER) -shift else shift
    var n = (ch - start) + sh
    n %= modulo
    if (n < 0) n += modulo
    return (start + n).toChar()
}

/* Caesar-shift a string on a pseudo-random stream */
fun caesarStr(m: CipherMode, msg: String, modulo: Int, start: Int): String {
    val sb = StringBuilder(msg.length)
    /* Caesar-shift message */
    for (c in msg) {
        sb.append(caesar(m, c.toInt(), iRandA(), modulo, start))
    }
    return sb.toString()
}

fun String.toHexByteString() =
    this.map { "%02X".format(it.toInt()) }.joinToString("")

fun main(args: Array<String>) {
    val msg = "a Top Secret secret"
    val key = "this is my secret key"

    // Vernam & Caesar ciphertext
    iSeed(key, true)
    val vctx = vernam(msg)
    val cctx = caesarStr(CipherMode.ENCIPHER, msg,  MOD, START)

    // Vernam & Caesar plaintext
    iSeed(key, true)
    val vptx = vernam(vctx)
    val cptx = caesarStr(CipherMode.DECIPHER, cctx, MOD, START)

    // Program output
    println("Message : $msg")
    println("Key     : $key")
    println("XOR     : ${vctx.toHexByteString()}")
    println("XOR dcr : $vptx")
    println("MOD     : ${cctx.toHexByteString()}")
    println("MOD dcr : $cptx")
}
