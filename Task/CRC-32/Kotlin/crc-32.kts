// version 1.0.6

import java.util.zip.CRC32

fun main(args: Array<String>) {
    val text = "The quick brown fox jumps over the lazy dog"
    val crc = CRC32()
    with (crc) {
        update(text.toByteArray())
        println("The CRC-32 checksum of '$text' = ${"%x".format(value)}")
    }
}
