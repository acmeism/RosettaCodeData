// Version 1.2.41

import java.awt.Color
import java.awt.Graphics
import java.awt.image.BufferedImage
import java.io.File
import javax.imageio.ImageIO
import kotlin.math.*

class BasicBitmapStorage(width: Int, height: Int) {
    val image = BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR)

    fun fill(c: Color) {
        val g = image.graphics
        g.color = c
        g.fillRect(0, 0, image.width, image.height)
    }

    fun setPixel(x: Int, y: Int, c: Color) = image.setRGB(x, y, c.getRGB())

    fun getPixel(x: Int, y: Int) = Color(image.getRGB(x, y))

    fun colorWheel() {
        val centerX = image.width / 2
        val centerY = image.height / 2
        val radius = minOf(centerX, centerY)
        for (y in 0 until image.height) {
            val dy = (y - centerY).toDouble()
            for (x in 0 until image.width) {
                val dx = (x - centerX).toDouble()
                val dist = sqrt(dx * dx + dy * dy)
                if (dist <= radius) {
                    val theta = atan2(dy, dx)
                    val hue = (theta + PI) / (2.0 * PI)
                    val rgb = Color.HSBtoRGB(hue.toFloat(), 1.0f, 1.0f)
                    setPixel(x, y, Color(rgb))
                }
            }
        }
    }
}

fun main(args: Array<String>) {
    val bbs = BasicBitmapStorage(480, 480)
    with (bbs) {
        fill(Color.white)
        colorWheel()
        val cwFile = File("Color_wheel.png")
        ImageIO.write(image, "png", cwFile)
    }
}
