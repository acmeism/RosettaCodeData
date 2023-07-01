// version 1.1.51

import java.io.InputStreamReader
import java.io.BufferedReader
import java.io.IOException

fun main(args: Array<String>) {
    try {
        val pb = ProcessBuilder()
        val currentUser = pb.environment().get("USER")
        val command = listOf("ps", "-f", "U", currentUser)
        pb.command(command)
        val proc = pb.start()
        val isr = InputStreamReader(proc.inputStream)
        val br = BufferedReader(isr)
        var line: String? = "Output of running $command is:"
        while(true) {
            println(line)
            line = br.readLine()
            if (line == null) break
        }
    }
    catch (iox: IOException) {
        iox.printStackTrace()
    }
}
