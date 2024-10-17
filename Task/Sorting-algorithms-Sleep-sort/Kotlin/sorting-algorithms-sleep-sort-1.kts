// version 1.1.51

import kotlin.concurrent.thread

fun sleepSort(list: List<Int>, interval: Long) {
    print("Sorted  : ")
    for (i in list) {
        thread {
            Thread.sleep(i * interval)
            print("$i ")
        }
    }
    thread { // print a new line after displaying sorted list
        Thread.sleep ((1 + list.max()!!) * interval)
        println()
    }
}

fun main(args: Array<String>) {
   val list = args.map { it.toInt() }.filter { it >= 0 } // ignore negative integers
   println("Unsorted: ${list.joinToString(" ")}")
   sleepSort(list, 50)
}
