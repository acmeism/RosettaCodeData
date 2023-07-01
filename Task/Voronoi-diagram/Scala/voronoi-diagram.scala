import java.awt.geom.Ellipse2D
import java.awt.image.BufferedImage
import java.awt.{Color, Graphics, Graphics2D}

import scala.math.sqrt

object Voronoi extends App {
  private val (cells, dim) = (100, 1000)
  private val rand = new scala.util.Random
  private val color = Vector.fill(cells)(rand.nextInt(0x1000000))
  private val image = new BufferedImage(dim, dim, BufferedImage.TYPE_INT_RGB)
  private val g: Graphics2D = image.createGraphics()
  private val px = Vector.fill(cells)(rand.nextInt(dim))
  private val py = Vector.fill(cells)(rand.nextInt(dim))

  for (x <- 0 until dim;
       y <- 0 until dim) {
    var n = 0

    def distance(x1: Int, x2: Int, y1: Int, y2: Int) =
      sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2).toDouble) // Euclidian

    for (i <- px.indices
         if distance(px(i), x, py(i), y) < distance(px(n), x, py(n), y))
      n = i
    image.setRGB(x, y, color(n))
  }

  g.setColor(Color.BLACK)
  for (i <- px.indices) g.fill(new Ellipse2D.Double(px(i) - 2.5, py(i) - 2.5, 5, 5))

  new javax.swing.JFrame("Voronoi Diagram") {
    override def paint(g: Graphics): Unit = {g.drawImage(image, 0, 0, this); ()}

    setBounds(0, 0, dim, dim)
    setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE)
    setLocationRelativeTo(null)
    setResizable(false)
    setVisible(true)
  }

}
