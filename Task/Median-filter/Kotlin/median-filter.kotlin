// Version 1.2.41
import java.awt.Color
import java.awt.Graphics
import java.awt.image.BufferedImage
import java.io.File
import javax.imageio.ImageIO

class BasicBitmapStorage(width: Int, height: Int) {
    val image = BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR)

    fun fill(c: Color) {
        val g = image.graphics
        g.color = c
        g.fillRect(0, 0, image.width, image.height)
    }

    fun setPixel(x: Int, y: Int, c: Color) = image.setRGB(x, y, c.getRGB())

    fun getPixel(x: Int, y: Int) = Color(image.getRGB(x, y))

    fun medianFilter(windowWidth: Int, windowHeight: Int) {
        val window = Array(windowWidth * windowHeight) { Color.black }
        val edgeX = windowWidth / 2
        val edgeY = windowHeight / 2
        val compareByLuminance = {
            c: Color -> 0.2126 * c.red + 0.7152 * c.green + 0.0722 * c.blue
        }
        for (x in edgeX until image.width - edgeX) {
            for (y in edgeY until image.height - edgeY) {
                var i = 0
                for (fx in 0 until windowWidth) {
                    for (fy in 0 until windowHeight) {
                        window[i] = getPixel(x + fx - edgeX, y + fy - edgeY)
                        i++
                    }
                }
                window.sortBy(compareByLuminance)
                setPixel(x, y, window[windowWidth * windowHeight / 2])
            }
        }
    }
}

fun main(args: Array<String>) {
    val img = ImageIO.read(File("Medianfilterp.png"))
    val bbs = BasicBitmapStorage(img.width / 2, img.height)
    with (bbs) {
        for (y in 0 until img.height) {
            for (x in 0 until img.width / 2) {
                setPixel(x, y, Color(img.getRGB(x, y)))
            }
        }
        medianFilter(3, 3)
        val mfFile = File("Medianfilterp2.png")
        ImageIO.write(image, "png", mfFile)
    }
}
