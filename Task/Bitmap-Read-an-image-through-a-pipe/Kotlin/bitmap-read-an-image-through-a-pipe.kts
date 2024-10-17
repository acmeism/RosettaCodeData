// Version 1.2.40

import java.awt.Color
import java.awt.Graphics
import java.awt.image.BufferedImage
import java.io.PushbackInputStream
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

    fun toGrayScale() {
        for (x in 0 until image.width) {
            for (y in 0 until image.height) {
                var rgb  = image.getRGB(x, y)
                val red   = (rgb shr 16) and 0xFF
                val green = (rgb shr  8) and 0xFF
                val blue  =  rgb and 0xFF
                val lumin = (0.2126 * red + 0.7152 * green + 0.0722 * blue).toInt()
                rgb = (lumin shl 16) or (lumin shl 8) or lumin
                image.setRGB(x, y, rgb)
            }
        }
    }
}

fun PushbackInputStream.skipComment() {
    while (read().toChar() != '\n') {}
}

fun PushbackInputStream.skipComment(buffer: ByteArray) {
    var nl: Int
    while (true) {
        nl = buffer.indexOf(10) // look for newline at end of comment
        if (nl != -1) break
        read(buffer)  // read another buffer full if newline not yet found
    }
    val len = buffer.size
    if (nl < len - 1) unread(buffer, nl + 1, len - nl - 1)
}

fun Byte.toUInt() = if (this < 0) 256 + this else this.toInt()

fun main(args: Array<String>) {
    // use file, output_piped.jpg, created in the
    // Bitmap/PPM conversion through a pipe task
    val pb = ProcessBuilder("convert", "output_piped.jpg", "ppm:-")
    pb.directory(null)
    pb.redirectOutput(ProcessBuilder.Redirect.PIPE)
    val proc = pb.start()
    val pStdOut = proc.inputStream
    val pbis = PushbackInputStream(pStdOut, 80)
    pbis.use {
        with (it) {
            val h1 = read().toChar()
            val h2 = read().toChar()
            val h3 = read().toChar()
            if (h1 != 'P' || h2 != '6' || h3 != '\n') {
                println("Not a P6 PPM file")
                System.exit(1)
            }
            val sb = StringBuilder()
            while (true) {
                val r = read().toChar()
                if (r == '#') { skipComment(); continue }
                if (r == ' ') break  // read until space reached
                sb.append(r.toChar())
            }
            val width = sb.toString().toInt()
            sb.setLength(0)
            while (true) {
                val r = read().toChar()
                if (r == '#') { skipComment(); continue }
                if (r == '\n') break  // read until new line reached
                sb.append(r.toChar())
            }
            val height = sb.toString().toInt()
            sb.setLength(0)
            while (true) {
                val r = read().toChar()
                if (r == '#') { skipComment(); continue }
                if (r == '\n') break  // read until new line reached
                sb.append(r.toChar())
            }
            val maxCol = sb.toString().toInt()
            if (maxCol !in 0..255) {
                println("Maximum color value is outside the range 0..255")
                System.exit(1)
            }
            var buffer = ByteArray(80)
            // get rid of any more opening comments before reading data
            while (true) {
                read(buffer)
                if (buffer[0].toChar() == '#') {
                    skipComment(buffer)
                }
                else {
                    unread(buffer)
                    break
                }
            }
            // read data
            val bbs = BasicBitmapStorage(width, height)
            buffer = ByteArray(width * 3)
            var y = 0
            while (y < height) {
                read(buffer)
                for (x in 0 until width) {
                    val c = Color(
                        buffer[x * 3].toUInt(),
                        buffer[x * 3 + 1].toUInt(),
                        buffer[x * 3 + 2].toUInt()
                    )
                    bbs.setPixel(x, y, c)
                }
                y++
            }
            // convert to grayscale and save to a file
            bbs.toGrayScale()
            val grayFile = File("output_piped_gray.jpg")
            ImageIO.write(bbs.image, "jpg", grayFile)
        }
    }
}
