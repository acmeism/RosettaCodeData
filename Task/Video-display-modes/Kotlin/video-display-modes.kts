// version 1.1.51

import java.util.Scanner

fun runSystemCommand(command: String) {
    val proc = Runtime.getRuntime().exec(command)
    Scanner(proc.inputStream).use {
        while (it.hasNextLine()) println(it.nextLine())
    }
    proc.waitFor()
    println()
}

fun main(args: Array<String>) {
    // query supported display modes
    runSystemCommand("xrandr -q")
    Thread.sleep(3000)

    // change display mode to 1024x768 say (no text output)
    runSystemCommand("xrandr -s 1024x768")
    Thread.sleep(3000)

    // change it back again to 1366x768 (or whatever is optimal for your system)
    runSystemCommand("xrandr -s 1366x768")
}
