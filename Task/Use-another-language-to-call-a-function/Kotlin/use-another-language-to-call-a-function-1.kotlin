// Kotlin Native v0.6

import kotlinx.cinterop.*
import platform.posix.*

fun query(data: CPointer<ByteVar>, length: CPointer<size_tVar>): Int {
    val s = "Here am I"
    val strLen = s.length
    val bufferSize = length.pointed.value
    if (strLen > bufferSize) return 0  // buffer not large enough
    for (i in 0 until strLen) data[i] = s[i].toByte()
    length.pointed.value = strLen.signExtend<size_t>()
    return 1
}
