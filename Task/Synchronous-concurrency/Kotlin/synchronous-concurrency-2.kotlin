// version 1.3.20 with kotlinx-coroutines-core version 1.1.1

import kotlinx.coroutines.async
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.sumBy
import kotlinx.coroutines.coroutineScope
import java.io.File

suspend fun main() {
    coroutineScope {
        val lines = Channel<String>()

        val count = async {
            lines.sumBy { line ->
                println(line)
                1
            }
        }

        File("input.txt").bufferedReader().forEachLine { line -> lines.send(line) }
        println("\nNumber of lines printed = ${count.await()}")
    }
}
