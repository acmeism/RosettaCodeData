import java.awt.image._
import java.io.File
import javax.imageio._

object HoughTransform extends App {
    override def main(args: Array[String]) {
        val inputData = readDataFromImage(args(0))
        val minContrast = if (args.length >= 4) 64 else args(4).toInt
        inputData(args(2).toInt, args(3).toInt, minContrast).writeOutputImage(args(1))
    }

    private def readDataFromImage(filename: String) = {
        val image = ImageIO.read(new File(filename))
        val width = image.getWidth
        val height = image.getHeight
        val rgbData = image.getRGB(0, 0, width, height, null, 0, width)
        val arrayData = new ArrayData(width, height)
        for (y <- 0 until height; x <- 0 until width) {
            var rgb = rgbData(y * width + x)
            rgb = (((rgb & 0xFF0000) >>> 16) * 0.30 + ((rgb & 0xFF00) >>> 8) * 0.59 +
                    (rgb & 0xFF) * 0.11).toInt
            arrayData(x, height - 1 - y) = rgb
        }
        arrayData
    }
}

class ArrayData(val width: Int, val height: Int) {
    def update(x: Int, y: Int, value: Int) {
        dataArray(x)(y) = value
    }

    def apply(thetaAxisSize: Int, rAxisSize: Int, minContrast: Int) = {
        val maxRadius = Math.ceil(Math.hypot(width, height)).toInt
        val halfRAxisSize = rAxisSize >>> 1
        val outputData = new ArrayData(thetaAxisSize, rAxisSize)
        val sinTable = Array.ofDim[Double](thetaAxisSize)
        val cosTable = sinTable.clone()
        for (theta <- thetaAxisSize - 1 until -1 by -1) {
            val thetaRadians = theta * Math.PI / thetaAxisSize
            sinTable(theta) = Math.sin(thetaRadians)
            cosTable(theta) = Math.cos(thetaRadians)
        }
        for (y <- height - 1 until -1 by -1; x <- width - 1 until -1 by -1)
            if (contrast(x, y, minContrast))
                for (theta <- thetaAxisSize - 1 until -1 by -1) {
                    val r = cosTable(theta) * x + sinTable(theta) * y
                    val rScaled = Math.round(r * halfRAxisSize / maxRadius).toInt + halfRAxisSize
                    outputData.dataArray(theta)(rScaled) += 1
                }

        outputData
    }

    def writeOutputImage(filename: String) {
        var max = Int.MinValue
        for (y <- 0 until height; x <- 0 until width) {
            val v = dataArray(x)(y)
            if (v > max) max = v
        }
        val image = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB)
        for (y <- 0 until height; x <- 0 until width) {
            val n = Math.min(Math.round(dataArray(x)(y) * 255.0 / max).toInt, 255)
            image.setRGB(x, height - 1 - y, (n << 16) | (n << 8) | 0x90 | -0x01000000)
        }
        ImageIO.write(image, "PNG", new File(filename))
    }

    private def contrast(x: Int, y: Int, minContrast: Int): Boolean = {
        val centerValue = dataArray(x)(y)
        for (i <- 8 until -1 by -1 if i != 4) {
            val newx = x + (i % 3) - 1
            val newy = y + (i / 3) - 1
            if (newx >= 0 && newx < width && newy >= 0 && newy < height &&
                    Math.abs(dataArray(newx)(newy) - centerValue) >= minContrast)
                return true
        }

        false
    }

    private val dataArray = Array.ofDim[Int](width, height)
}
