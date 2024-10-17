// version 1.1.2

import java.awt.*
import javax.swing.*

class FibonacciWordFractal(n: Int) : JPanel() {
    private val wordFractal: String

    init {
        preferredSize = Dimension(450, 620)
        background = Color.black
        wordFractal = wordFractal(n)
    }

    fun wordFractal(i: Int): String {
        if (i < 2) return if (i == 1) "1" else ""
        val f1 = StringBuilder("1")
        val f2 = StringBuilder("0")

        for (j in i - 2 downTo 1) {
            val tmp = f2.toString()
            f2.append(f1)
            f1.setLength(0)
            f1.append(tmp)
        }

        return f2.toString()
    }

    private fun drawWordFractal(g: Graphics2D, x: Int, y: Int, dx: Int, dy: Int) {
        var x2 = x
        var y2 = y
        var dx2 = dx
        var dy2 = dy
        for (i in 0 until wordFractal.length) {
            g.drawLine(x2, y2, x2 + dx2, y2 + dy2)
            x2 += dx2
            y2 += dy2
            if (wordFractal[i] == '0') {
                val tx = dx2
                dx2 = if (i % 2 == 0) -dy2 else dy2
                dy2 = if (i % 2 == 0) tx else -tx
            }
        }
    }

    override fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.color = Color.green
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                           RenderingHints.VALUE_ANTIALIAS_ON)
        drawWordFractal(g, 20, 20, 1, 0)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        with(f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            title = "Fibonacci Word Fractal"
            isResizable = false
            add(FibonacciWordFractal(23), BorderLayout.CENTER)
            pack()
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}
