// version 1.1.2

import java.awt.Robot
import java.awt.event.InputEvent

fun sendClick(buttons: Int) {
    val r = Robot()
    r.mousePress(buttons)
    r.mouseRelease(buttons)
}

fun main(args: Array<String>) {
    sendClick(InputEvent.BUTTON3_DOWN_MASK) // simulate a click of the mouse's right button
}
