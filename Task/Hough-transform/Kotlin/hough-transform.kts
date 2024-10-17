import java.awt.image.BufferedImage
import java.io.File
import javax.imageio.ImageIO

internal class ArrayData(val dataArray: IntArray, val width: Int, val height: Int) {

    constructor(width: Int, height: Int) : this(IntArray(width * height), width, height)

    operator fun get(x: Int, y: Int) = dataArray[y * width + x]

    operator fun set(x: Int, y: Int, value: Int) {
        dataArray[y * width + x] = value
    }

    operator fun invoke(thetaAxisSize: Int, rAxisSize: Int, minContrast: Int): ArrayData {
        val maxRadius = Math.ceil(Math.hypot(width.toDouble(), height.toDouble())).toInt()
        val halfRAxisSize = rAxisSize.ushr(1)
        val outputData = ArrayData(thetaAxisSize, rAxisSize)
        // x output ranges from 0 to pi
        // y output ranges from -maxRadius to maxRadius
        val sinTable = DoubleArray(thetaAxisSize)
        val cosTable = DoubleArray(thetaAxisSize)
        for (theta in thetaAxisSize - 1 downTo 0) {
            val thetaRadians = theta * Math.PI / thetaAxisSize
            sinTable[theta] = Math.sin(thetaRadians)
            cosTable[theta] = Math.cos(thetaRadians)
        }

        for (y in height - 1 downTo 0)
            for (x in width - 1 downTo 0)
                if (contrast(x, y, minContrast))
                    for (theta in thetaAxisSize - 1 downTo 0) {
                        val r = cosTable[theta] * x + sinTable[theta] * y
                        val rScaled = Math.round(r * halfRAxisSize / maxRadius).toInt() + halfRAxisSize
                        outputData.accumulate(theta, rScaled, 1)
                    }

        return outputData
    }

    fun writeOutputImage(filename: String) {
        val max = dataArray.max()!!
        val image = BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB)
        for (y in 0..height - 1)
            for (x in 0..width - 1) {
                val n = Math.min(Math.round(this[x, y] * 255.0 / max).toInt(), 255)
                image.setRGB(x, height - 1 - y, n shl 16 or (n shl 8) or 0x90 or -0x01000000)
            }

        ImageIO.write(image, "PNG", File(filename))
    }

    private fun accumulate(x: Int, y: Int, delta: Int) {
        set(x, y, get(x, y) + delta)
    }

    private fun contrast(x: Int, y: Int, minContrast: Int): Boolean {
        val centerValue = get(x, y)
        for (i in 8 downTo 0)
            if (i != 4) {
                val newx = x + i % 3 - 1
                val newy = y + i / 3 - 1
                if (newx >= 0 && newx < width && newy >= 0 && newy < height
                        && Math.abs(get(newx, newy) - centerValue) >= minContrast)
                    return true
            }
        return false
    }
}

internal fun readInputFromImage(filename: String): ArrayData {
    val image = ImageIO.read(File(filename))
    val w = image.width
    val h = image.height
    val rgbData = image.getRGB(0, 0, w, h, null, 0, w)
    // flip y axis when reading image
    val array = ArrayData(w, h)
    for (y in 0..h - 1)
        for (x in 0..w - 1) {
            var rgb = rgbData[y * w + x]
            rgb = ((rgb and 0xFF0000).ushr(16) * 0.30 + (rgb and 0xFF00).ushr(8) * 0.59 + (rgb and 0xFF) * 0.11).toInt()
            array[x, h - 1 - y] = rgb
        }

    return array
}

fun main(args: Array<out String>) {
    val inputData = readInputFromImage(args[0])
    val minContrast = if (args.size >= 4) 64 else args[4].toInt()
    inputData(args[2].toInt(), args[3].toInt(), minContrast).writeOutputImage(args[1])
}
