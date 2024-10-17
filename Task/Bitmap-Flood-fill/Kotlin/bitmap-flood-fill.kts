// version 1.1.4-3

import java.awt.Color
import java.awt.Point
import java.awt.image.BufferedImage
import java.util.LinkedList
import java.io.File
import javax.imageio.ImageIO
import javax.swing.JOptionPane
import javax.swing.JLabel
import javax.swing.ImageIcon

fun floodFill(image: BufferedImage, node: Point, targetColor: Color, replColor: Color) {
    val target = targetColor.getRGB()
    val replacement = replColor.getRGB()
    if (target == replacement) return
    val width = image.width
    val height = image.height
    val queue = LinkedList<Point>()
    var nnode: Point? = node

    do {
        var x = nnode!!.x
        val y = nnode.y
        while (x > 0 && image.getRGB(x - 1, y) == target) x--
        var spanUp = false
        var spanDown = false

        while (x < width && image.getRGB(x, y) == target) {
            image.setRGB(x, y, replacement)

            if (!spanUp && y > 0 && image.getRGB(x, y - 1) == target) {
                queue.add(Point(x, y - 1))
                spanUp = true
            }
            else if (spanUp && y > 0 && image.getRGB(x, y - 1) != target) {
                spanUp = false
            }

            if (!spanDown && y < height - 1 && image.getRGB(x, y + 1) == target) {
                queue.add(Point(x, y + 1))
                spanDown = true
            }
            else if (spanDown && y < height - 1 && image.getRGB(x, y + 1) != target) {
                spanDown = false
            }
            x++
        }
        nnode = queue.pollFirst()
    }
    while (nnode != null)
}

fun main(args: Array<String>) {
   val image = ImageIO.read(File("Unfilledcirc.png"))
   floodFill(image, Point(50, 50), Color.white, Color.yellow)
   val title = "Floodfilledcirc.png"
   ImageIO.write(image, "png", File(title))
   JOptionPane.showMessageDialog(null, JLabel(ImageIcon(image)), title, JOptionPane.PLAIN_MESSAGE)
}
