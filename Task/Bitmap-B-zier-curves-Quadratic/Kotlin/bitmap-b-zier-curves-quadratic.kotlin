// Version 1.2.40

import java.awt.Color
import java.awt.Graphics
import java.awt.image.BufferedImage
import kotlin.math.abs
import java.io.File
import javax.imageio.ImageIO

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

    fun quadraticBezier(p1: Point, p2: Point, p3: Point, clr: Color, n: Int) {
        val pts = List(n + 1) { Point(0, 0) }
        for (i in 0..n) {
            val t = i.toDouble() / n
            val u = 1.0 - t
            val a = u * u
            val b = 2.0 * t * u
            val c = t * t
            pts[i].x = (a * p1.x + b * p2.x + c * p3.x).toInt()
            pts[i].y = (a * p1.y + b * p2.y + c * p3.y).toInt()
            setPixel(pts[i].x, pts[i].y, clr)
        }
        for (i in 0 until n) {
            val j = i + 1
            drawLine(pts[i].x, pts[i].y, pts[j].x, pts[j].y, clr)
        }
    }
}

fun main(args: Array<String>) {
    val width = 320
    val height = 320
    val bbs = BasicBitmapStorage(width, height)
    with (bbs) {
        fill(Color.cyan)
        val p1 = Point(10, 100)
        val p2 = Point(250, 270)
        val p3 = Point(150, 20)
        quadraticBezier(p1, p2, p3, Color.black, 20)
        val qbFile = File("quadratic_bezier.jpg")
        ImageIO.write(image, "jpg", qbFile)
    }
}
