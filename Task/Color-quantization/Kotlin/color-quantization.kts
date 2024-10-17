// Version 1.2.41

import java.io.BufferedReader
import java.io.InputStreamReader

fun main(args: Array<String>) {
    // convert 'frog' to an image which uses only 16 colors, no dithering
    val pb = ProcessBuilder(
        "convert",
        "Quantum_frog.png",
        "-dither",
        "None",
        "-colors",
        "16",
        "Quantum_frog_16.png"
    )
    pb.directory(null)
    val proc = pb.start()
    proc.waitFor()

    // now show the colors used
    val pb2 = ProcessBuilder(
       "convert",
       "Quantum_frog_16.png",
       "-format",
       "%c",
       "-depth",
       "8",
       "histogram:info:-"
    )
    pb2.directory(null)
    pb.redirectOutput(ProcessBuilder.Redirect.PIPE)
    val proc2 = pb2.start()
    val br = BufferedReader(InputStreamReader(proc2.inputStream))
    var clrNum = 0
    while (true) {
        val line = br.readLine() ?: break
        System.out.printf("%2d->%s\n", clrNum++, line)
    }
    br.close()
}
