// Version 1.2.41

import java.awt.Color
import java.awt.Graphics
import java.awt.image.BufferedImage
import kotlin.math.*
import java.io.File
import javax.imageio.ImageIO

val Double.asI get() = this.toInt()

class Point(var x: Int, var y: Int)

class BasicBitmapStorage(width: Int, height: Int) {
    val image = BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR)

    fun fill(c: Color) {
        val g = image.graphics
        g.color = c
        g.fillRect(0, 0, image.width, image.height)
    }

    fun setPixel(x: Int, y: Int, c: Color) = image.setRGB(x, y, c.getRGB())

    fun getPixel(x: Int, y: Int) = Color(image.getRGB(x, y))

    fun drawLine(x0: Int, y0: Int, x1: Int, y1: Int, c: Color) {
        val dx = abs(x1 - x0)
        val dy = abs(y1 - y0)
        val sx = if (x0 < x1) 1 else -1
        val sy = if (y0 < y1) 1 else -1
        var xx = x0
        var yy = y0
        var e1 = (if (dx > dy) dx else -dy) / 2
        var e2: Int
        while (true) {
            setPixel(xx, yy, c)
            if (xx == x1 && yy == y1) break
            e2 = e1
            if (e2 > -dx) { e1 -= dy; xx += sx }
            if (e2 <  dy) { e1 += dx; yy += sy }
        }
    }

    fun koch(x1: Double, y1: Double, x2: Double, y2: Double, it: Int) {
        val angle = PI / 3.0  // 60 degrees
        val clr = Color.blue
        var iter = it
        val x3 = (x1 * 2.0 + x2) / 3.0
        val y3 = (y1 * 2.0 + y2) / 3.0
        val x4 = (x1 + x2 * 2.0) / 3.0
        val y4 = (y1 + y2 * 2.0) / 3.0
        val x5 = x3 + (x4 - x3) * cos(angle) + (y4 - y3) * sin(angle)
        val y5 = y3 - (x4 - x3) * sin(angle) + (y4 - y3) * cos(angle)

        if (iter > 0) {
            iter--
            koch(x1, y1, x3, y3, iter)
            koch(x3, y3, x5, y5, iter)
            koch(x5, y5, x4, y4, iter)
            koch(x4, y4, x2, y2, iter)
         }
         else {
            drawLine(x1.asI, y1.asI, x3.asI, y3.asI, clr)
            drawLine(x3.asI, y3.asI, x5.asI, y5.asI, clr)
            drawLine(x5.asI, y5.asI, x4.asI, y4.asI, clr)
            drawLine(x4.asI, y4.asI, x2.asI, y2.asI, clr)
         }
    }
}

fun main(args: Array<String>) {
    val width = 512
    val height = 512
    val bbs = BasicBitmapStorage(width, height)
    with (bbs) {
        fill(Color.white)
        koch(100.0, 100.0, 400.0, 400.0, 4)
        val kFile = File("koch_curve.jpg")
        ImageIO.write(image, "jpg", kFile)
    }
}
