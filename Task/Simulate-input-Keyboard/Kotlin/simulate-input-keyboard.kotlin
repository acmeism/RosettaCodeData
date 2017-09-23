// version 1.1.2

import java.awt.Robot
import java.awt.event.KeyEvent

fun sendChars(s: String, pressReturn: Boolean = true) {
    val r = Robot()
    for (c in s) {
        val ci = c.toUpperCase().toInt()
        r.keyPress(ci)
        r.keyRelease(ci)
    }
    if (pressReturn) {
        r.keyPress(KeyEvent.VK_ENTER)
        r.keyRelease(KeyEvent.VK_ENTER)
    }
}

fun main(args: Array<String>) {
    sendChars("dir")  // runs 'dir' command
}
