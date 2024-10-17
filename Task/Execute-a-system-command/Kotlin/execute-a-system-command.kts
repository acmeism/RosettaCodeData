// version 1.0.6

import java.util.Scanner

fun main(args: Array<String>) {
    val proc = Runtime.getRuntime().exec("cmd /C dir")  // testing on Windows 10
    Scanner(proc.inputStream).use {
        while (it.hasNextLine()) println(it.nextLine())
    }
}
