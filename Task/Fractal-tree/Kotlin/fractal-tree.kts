// version 1.1.2

import java.awt.Color
import java.awt.Graphics
import javax.swing.JFrame

class FractalTree : JFrame("Fractal Tree") {
    init {
        background = Color.black
        setBounds(100, 100, 800, 600)
        isResizable = false
        defaultCloseOperation = EXIT_ON_CLOSE
    }

    private fun drawTree(g: Graphics, x1: Int, y1: Int, angle: Double, depth: Int) {
        if (depth == 0) return
        val x2 = x1 + (Math.cos(Math.toRadians(angle)) * depth * 10.0).toInt()
        val y2 = y1 + (Math.sin(Math.toRadians(angle)) * depth * 10.0).toInt()
        g.drawLine(x1, y1, x2, y2)
        drawTree(g, x2, y2, angle - 20, depth - 1)
        drawTree(g, x2, y2, angle + 20, depth - 1)
    }

    override fun paint(g: Graphics) {
        g.color = Color.white
        drawTree(g, 400, 500, -90.0, 9)
    }
}

fun main(args: Array<String>) {
    FractalTree().isVisible = true
}
