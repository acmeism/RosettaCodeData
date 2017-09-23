// version 1.0.6

import java.security.MessageDigest

class MD4() : MessageDigest("MD4"), Cloneable {
    private val blockLength = 64
    private var context = IntArray(4)
    private var count = 0L
    private var buffer = ByteArray(blockLength)
    private var x = IntArray(16)

    init {
        engineReset()
    }

    private constructor(md: MD4): this() {
        context = md.context.clone()
        buffer = md.buffer.clone()
        count = md.count
    }

    override fun clone(): Any = MD4(this)

    override fun engineReset() {
        context[0] = 0x67452301
        context[1] = 0xefcdab89.toInt()
        context[2] = 0x98badcfe.toInt()
        context[3] = 0x10325476
        count = 0L
        for (i in 0 until blockLength) buffer[i] = 0
    }

    override fun engineUpdate(b: Byte) {
        val i = (count % blockLength).toInt()
        count++
        buffer[i] = b
        if (i == blockLength - 1) transform(buffer, 0)
    }

    override fun engineUpdate(input: ByteArray, offset: Int, len: Int) {
        if (offset < 0 || len < 0 || offset.toLong() + len > input.size.toLong())
            throw ArrayIndexOutOfBoundsException()
        var bufferNdx = (count % blockLength).toInt()
        count += len
        val partLen = blockLength - bufferNdx
        var i = 0
        if (len >= partLen) {
            System.arraycopy(input, offset, buffer, bufferNdx, partLen)
            transform(buffer, 0)
            i = partLen
            while (i + blockLength - 1 < len) {
                transform(input, offset + i)
                i += blockLength
            }
            bufferNdx = 0
        }
        if (i < len) System.arraycopy(input, offset + i, buffer, bufferNdx, len - i)
    }

    override fun engineDigest(): ByteArray {
        val bufferNdx = (count % blockLength).toInt()
        val padLen = if (bufferNdx < 56) 56 - bufferNdx else 120 - bufferNdx
        val tail = ByteArray(padLen + 8)
        tail[0] = 0x80.toByte()
        for (i in 0..7) tail[padLen + i] = ((count * 8) ushr (8 * i)).toByte()
        engineUpdate(tail, 0, tail.size)
        val result = ByteArray(16)
        for (i in 0..3)
            for (j in 0..3)
                result[i * 4 + j] = (context[i] ushr (8 * j)).toByte()
        engineReset()
        return result
    }

    private fun transform (block: ByteArray, offset: Int) {
        var offset2 = offset
        for (i in 0..15)
            x[i] = ((block[offset2++].toInt() and 0xff)       ) or
                   ((block[offset2++].toInt() and 0xff) shl 8 ) or
                   ((block[offset2++].toInt() and 0xff) shl 16) or
                   ((block[offset2++].toInt() and 0xff) shl 24)

        var a = context[0]
        var b = context[1]
        var c = context[2]
        var d = context[3]

        a = ff(a, b, c, d, x[ 0],  3)
        d = ff(d, a, b, c, x[ 1],  7)
        c = ff(c, d, a, b, x[ 2], 11)
        b = ff(b, c, d, a, x[ 3], 19)
        a = ff(a, b, c, d, x[ 4],  3)
        d = ff(d, a, b, c, x[ 5],  7)
        c = ff(c, d, a, b, x[ 6], 11)
        b = ff(b, c, d, a, x[ 7], 19)
        a = ff(a, b, c, d, x[ 8],  3)
        d = ff(d, a, b, c, x[ 9],  7)
        c = ff(c, d, a, b, x[10], 11)
        b = ff(b, c, d, a, x[11], 19)
        a = ff(a, b, c, d, x[12],  3)
        d = ff(d, a, b, c, x[13],  7)
        c = ff(c, d, a, b, x[14], 11)
        b = ff(b, c, d, a, x[15], 19)

        a = gg(a, b, c, d, x[ 0],  3)
        d = gg(d, a, b, c, x[ 4],  5)
        c = gg(c, d, a, b, x[ 8],  9)
        b = gg(b, c, d, a, x[12], 13)
        a = gg(a, b, c, d, x[ 1],  3)
        d = gg(d, a, b, c, x[ 5],  5)
        c = gg(c, d, a, b, x[ 9],  9)
        b = gg(b, c, d, a, x[13], 13)
        a = gg(a, b, c, d, x[ 2],  3)
        d = gg(d, a, b, c, x[ 6],  5)
        c = gg(c, d, a, b, x[10],  9)
        b = gg(b, c, d, a, x[14], 13)
        a = gg(a, b, c, d, x[ 3],  3)
        d = gg(d, a, b, c, x[ 7],  5)
        c = gg(c, d, a, b, x[11],  9)
        b = gg(b, c, d, a, x[15], 13)

        a = hh(a, b, c, d, x[ 0],  3)
        d = hh(d, a, b, c, x[ 8],  9)
        c = hh(c, d, a, b, x[ 4], 11)
        b = hh(b, c, d, a, x[12], 15)
        a = hh(a, b, c, d, x[ 2],  3)
        d = hh(d, a, b, c, x[10],  9)
        c = hh(c, d, a, b, x[ 6], 11)
        b = hh(b, c, d, a, x[14], 15)
        a = hh(a, b, c, d, x[ 1],  3)
        d = hh(d, a, b, c, x[ 9],  9)
        c = hh(c, d, a, b, x[ 5], 11)
        b = hh(b, c, d, a, x[13], 15)
        a = hh(a, b, c, d, x[ 3],  3)
        d = hh(d, a, b, c, x[11],  9)
        c = hh(c, d, a, b, x[ 7], 11)
        b = hh(b, c, d, a, x[15], 15)

        context[0] += a
        context[1] += b
        context[2] += c
        context[3] += d
    }

    private fun ff(a: Int, b: Int, c: Int, d: Int, x: Int, s: Int): Int {
        val t = a + ((b and c) or (b.inv() and d)) + x
        return (t shl s) or (t ushr (32 - s))
    }

    private fun gg(a: Int, b: Int, c: Int, d: Int, x: Int, s: Int): Int {
        val t = a + ((b and (c or d)) or (c and d)) + x + 0x5a827999
        return (t shl s) or (t ushr (32 - s))
    }

    private fun hh(a: Int, b: Int, c: Int, d: Int, x: Int, s: Int): Int {
        val t = a + (b xor c xor d) + x + 0x6ed9eba1
        return (t shl s) or (t ushr (32 - s))
    }
}

fun main(args: Array<String>) {
    val text  = "Rosetta Code"
    val bytes = text.toByteArray(Charsets.US_ASCII)
    val md: MessageDigest = MD4()
    val digest = md.digest(bytes)
    for (byte in digest) print("%02x".format(byte))
    println()
}
