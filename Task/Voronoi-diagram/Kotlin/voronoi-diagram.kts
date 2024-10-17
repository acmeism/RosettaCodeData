// version 1.1.3

import java.awt.Color
import java.awt.Graphics
import java.awt.Graphics2D
import java.awt.geom.Ellipse2D
import java.awt.image.BufferedImage
import java.util.Random
import javax.swing.JFrame

fun distSq(x1: Int, x2: Int, y1: Int, y2: Int): Int {
    val x = x1 - x2
    val y = y1 - y2
    return x * x + y * y
}

class Voronoi(val cells: Int, val size: Int) : JFrame("Voronoi Diagram") {
    val bi: BufferedImage

    init {
        setBounds(0, 0, size, size)
        defaultCloseOperation = EXIT_ON_CLOSE
        val r = Random()
        bi = BufferedImage(size, size, BufferedImage.TYPE_INT_RGB)
        val px = IntArray(cells) { r.nextInt(size) }
        val py = IntArray(cells) { r.nextInt(size) }
        val cl = IntArray(cells) { r.nextInt(16777215) }
        for (x in 0 until size) {
            for (y in 0 until size) {
                var n = 0
                for (i in 0 until cells) {
                    if (distSq(px[i], x, py[i], y) < distSq(px[n], x, py[n], y)) n = i
                }
                bi.setRGB(x, y, cl[n])
            }
        }
        val g = bi.createGraphics()
        g.color = Color.BLACK
        for (i in 0 until cells) {
            g.fill(Ellipse2D.Double(px[i] - 2.5, py[i] - 2.5, 5.0, 5.0))
        }
    }

    override fun paint(g: Graphics) {
        g.drawImage(bi, 0, 0, this)
    }
}

fun main(args: Array<String>) {
    Voronoi(70, 700).isVisible = true
}
