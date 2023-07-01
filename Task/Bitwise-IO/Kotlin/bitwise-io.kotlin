// version 1.2.31

import java.io.File

class BitFilter(val f: File, var accu: Int = 0, var bits: Int = 0) {

    private val bw = f.bufferedWriter()
    private val br = f.bufferedReader()

    fun write(buf: ByteArray, start: Int, _nBits: Int, _shift: Int) {
        var nBits = _nBits
        var index = start + _shift / 8
        var shift = _shift % 8

        while (nBits != 0 || bits >= 8) {
            while (bits >= 8) {
                bits -= 8
                bw.write(accu ushr bits)
                accu = accu and ((1 shl bits) - 1)
            }
            while (bits < 8 && nBits != 0) {
                val b = buf[index].toInt()
                accu = (accu shl 1) or (((128 ushr shift) and b) ushr (7 - shift))
                nBits--
                bits++
                if (++shift == 8) { shift = 0; index++ }
            }
        }
    }

    fun read(buf: ByteArray, start: Int, _nBits: Int, _shift: Int) {
        var nBits = _nBits
        var index = start + _shift / 8
        var shift = _shift % 8

        while (nBits != 0) {
            while (bits != 0 && nBits != 0) {
                val mask = 128 ushr shift
                if ((accu and (1 shl (bits - 1))) != 0)
                    buf[index] = (buf[index].toInt() or mask).toByte()
                else
                    buf[index] = (buf[index].toInt() and mask.inv()).toByte()
                nBits--
                bits--
                if (++shift >= 8) { shift = 0; index++ }
            }
            if (nBits == 0) break
            accu = (accu shl 8) or br.read()
            bits += 8
        }
    }

    fun closeWriter() {
        if (bits != 0) {
            accu = (accu shl (8 - bits))
            bw.write(accu)
        }
        bw.close()
        accu = 0
        bits = 0
    }

    fun closeReader() {
        br.close()
        accu = 0
        bits = 0
    }
}

fun main(args: Array<String>) {
    val s = "abcdefghijk".toByteArray(Charsets.UTF_8)
    val f = File("test.bin")
    val bf = BitFilter(f)

    /* for each byte in s, write 7 bits skipping 1 */
    for (i in 0 until s.size) bf.write(s, i, 7, 1)
    bf.closeWriter()

    /* read 7 bits and expand to each byte of s2 skipping 1 bit */
    val s2 = ByteArray(s.size)
    for (i in 0 until s2.size) bf.read(s2, i, 7, 1)
    bf.closeReader()
    println(String(s2, Charsets.UTF_8))
}
