// version 1.1.0

import java.awt.Dimension
import java.awt.event.MouseAdapter
import java.awt.event.MouseEvent
import java.util.*
import javax.swing.JFrame
import javax.swing.JLabel

class Rotate : JFrame() {
    val text = "Hello World! "
    val label = JLabel(text)
    var rotRight = true
    var startIdx = 0

    init {
        preferredSize = Dimension(96, 64)
        label.addMouseListener(object: MouseAdapter() {
            override fun mouseClicked(evt: MouseEvent) {
                rotRight = !rotRight
            }
        })
        add(label)
        pack()
        defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        isVisible = true
    }
}

fun getRotatedText(text: String, startIdx: Int): String {
    val ret = StringBuilder()
    var i = startIdx
    do {
        ret.append(text[i++])
        i %= text.length
    }
    while (i != startIdx)
    return ret.toString()
}

fun main(args: Array<String>) {
    val rot = Rotate()
    val task = object : TimerTask() {
        override fun run() {
            if (rot.rotRight) {
                if (--rot.startIdx < 0) rot.startIdx += rot.text.length
            }
            else {
                if (++rot.startIdx >= rot.text.length) rot.startIdx -= rot.text.length
            }
            rot.label.text = getRotatedText(rot.text, rot.startIdx)
        }
    }
    Timer(false).schedule(task, 0, 500)
}
