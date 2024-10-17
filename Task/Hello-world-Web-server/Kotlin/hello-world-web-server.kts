import java.io.PrintWriter
import java.net.ServerSocket

fun main(args: Array<String>) {
    val listener = ServerSocket(8080)
    while(true) {
        val sock = listener.accept()
        PrintWriter(sock.outputStream, true).println("Goodbye, World!")
        sock.close()
    }
}
