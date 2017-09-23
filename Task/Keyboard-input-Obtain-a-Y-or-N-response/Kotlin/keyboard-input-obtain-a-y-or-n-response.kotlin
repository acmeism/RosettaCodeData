// version 1.0.6

import java.awt.event.KeyAdapter
import java.awt.event.KeyEvent
import javax.swing.JFrame
import javax.swing.SwingUtilities

class Test: JFrame() {
    init {
        while (System.`in`.available() > 0) System.`in`.read()
        println("Do you want to quit Y/N")
        addKeyListener(object: KeyAdapter() {
            override fun keyPressed(e: KeyEvent) {
                if (e.keyCode == KeyEvent.VK_Y) {
                    println("OK, quitting")
                    quit()
                } else if (e.keyCode == KeyEvent.VK_N) {
                    println("N was pressed but the program is about to end anyway")
                    quit()
                } else {
                    println("Only Y/N are acceptable, please try again")
                }
            }
        })
    }

    private fun quit() {
        isVisible = false
        dispose()
        System.exit(0)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = Test()
        f.isFocusable = true
        f.isVisible = true
    }
}
