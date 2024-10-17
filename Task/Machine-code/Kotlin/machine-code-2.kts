// Kotlin Native version 0.3

import kotlinx.cinterop.*
import string.*
import mman.*
import mcode.*

fun main(args: Array<String>) {
    memScoped {
        val bytes = byteArrayOf(
            144 - 256,                            // Align
            144 - 256,
            106, 12,                              // Prepare stack
            184 - 256, 7, 0, 0, 0,
            72, 193 - 256, 224 - 256, 32,
            80,
            139 - 256, 68, 36, 4, 3, 68, 36, 8,   // Rosetta task code
            76, 137 - 256, 227 - 256,             // Get result
            137 - 256, 195 - 256,
            72, 193 - 256, 227 - 256, 4,
            128 - 256, 203 - 256, 2,
            72, 131 - 256, 196 - 256, 16,         // Clean up stack
            195 - 256                             // Return
        )
        val len = bytes.size
        val code = allocArray<ByteVar>(len)
        for (i in 0 until len) code[i] = bytes[i]
        val buf = mmap(null, len.toLong(), PROT_READ or PROT_WRITE or PROT_EXEC,
                       MAP_PRIVATE or MAP_ANON, -1, 0)
        memcpy(buf, code, len.toLong())
        val a: Byte = 7
        val b: Byte = 12
        val c = runMachineCode(buf, a, b)
        munmap(buf, len.toLong())
        println("$a + $b = ${if(c >= 0) c.toInt() else c + 256}")
    }
}
