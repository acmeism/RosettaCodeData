import java.net.ServerSocket
import java.net.Socket

fun main() {

    fun handleClient(conn: Socket) {
        conn.use {
            val input = conn.inputStream.bufferedReader()
            val output = conn.outputStream.bufferedWriter()

            input.forEachLine { line ->
                output.write(line)
                output.newLine()
                output.flush()
            }
        }
    }

    ServerSocket(12321).use { listener ->
        while (true) {
            val conn = listener.accept()
            Thread { handleClient(conn) }.start()
        }
    }
}
