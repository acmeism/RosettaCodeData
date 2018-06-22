// version 1.2.21

import java.net.Socket

fun main(args: Array<String>) {
    val sock = Socket("localhost", 256)
    sock.use {
        it.outputStream.write("hello socket world".toByteArray())
    }
}
