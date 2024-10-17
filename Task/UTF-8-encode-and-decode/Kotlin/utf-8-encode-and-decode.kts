// version 1.1.2

fun utf8Encode(codePoint: Int) = String(intArrayOf(codePoint), 0, 1).toByteArray(Charsets.UTF_8)

fun utf8Decode(bytes: ByteArray) = String(bytes, Charsets.UTF_8).codePointAt(0)

fun main(args: Array<String>) {
    val codePoints = intArrayOf(0x0041, 0x00F6, 0x0416, 0x20AC, 0x1D11E)
    println("Char  Name                                 Unicode  UTF-8         Decoded")
    for (codePoint in codePoints) {
        var n = if(codePoint <= 0xFFFF) 4 else 5
        System.out.printf("%-${n}c  %-35s  U+%05X  ", codePoint, Character.getName(codePoint), codePoint)
        val bytes = utf8Encode(codePoint)
        var s = ""
        for (byte in bytes) s += "%02X ".format(byte)
        val decoded = utf8Decode(bytes)
        n = if(decoded.toInt() <= 0xFFFF) 12 else 11
        System.out.printf("%-${n}s  %c\n", s, decoded)
    }
}
