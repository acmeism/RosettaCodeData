// version 1.1

import java.awt.*
import javax.swing.*

class RotatingCube : JPanel() {
    private val nodes = arrayOf(
        doubleArrayOf(-1.0, -1.0, -1.0),
        doubleArrayOf(-1.0, -1.0,  1.0),
        doubleArrayOf(-1.0,  1.0, -1.0),
        doubleArrayOf(-1.0,  1.0,  1.0),
        doubleArrayOf( 1.0, -1.0, -1.0),
        doubleArrayOf( 1.0, -1.0,  1.0),
        doubleArrayOf( 1.0,  1.0, -1.0),
        doubleArrayOf( 1.0,  1.0,  1.0)
    )
    private val edges = arrayOf(
        intArrayOf(0, 1),
        intArrayOf(1, 3),
        intArrayOf(3, 2),
        intArrayOf(2, 0),
        intArrayOf(4, 5),
        intArrayOf(5, 7),
        intArrayOf(7, 6),
        intArrayOf(6, 4),
        intArrayOf(0, 4),
        intArrayOf(1, 5),
        intArrayOf(2, 6),
        intArrayOf(3, 7)
    )

    init {
        preferredSize = Dimension(640, 640)
        background = Color.white
        scale(100.0)
        rotateCube(Math.PI / 4.0, Math.atan(Math.sqrt(2.0)))
        Timer(17) {
            rotateCube(Math.PI / 180.0, 0.0)
            repaint()
        }.start()
    }

    private fun scale(s: Double) {
        for (node in nodes) {
            node[0] *= s
            node[1] *= s
            node[2] *= s
        }
    }

    private fun rotateCube(angleX: Double, angleY: Double) {
        val sinX = Math.sin(angleX)
        val cosX = Math.cos(angleX)
        val sinY = Math.sin(angleY)
        val cosY = Math.cos(angleY)
        for (node in nodes) {
            val x = node[0]
            val y = node[1]
            var z = node[2]
            node[0] = x * cosX - z * sinX
            node[2] = z * cosX + x * sinX
            z = node[2]
            node[1] = y * cosY - z * sinY
            node[2] = z * cosY + y * sinY
        }
    }

    private fun drawCube(g: Graphics2D) {
        g.translate(width / 2, height / 2)
        for (edge in edges) {
            val xy1 = nodes[edge[0]]
            val xy2 = nodes[edge[1]]
            g.drawLine(Math.round(xy1[0]).toInt(), Math.round(xy1[1]).toInt(),
                       Math.round(xy2[0]).toInt(), Math.round(xy2[1]).toInt())
        }
        for (node in nodes) {
            g.fillOval(Math.round(node[0]).toInt() - 4, Math.round(node[1]).toInt() - 4, 8, 8)
        }
    }

    override public fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        g.color = Color.blue
        drawCube(g)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        f.defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        f.title = "Rotating cube"
        f.isResizable = false
        f.add(RotatingCube(), BorderLayout.CENTER)
        f.pack()
        f.setLocationRelativeTo(null)
        f.isVisible = true
    }
}
