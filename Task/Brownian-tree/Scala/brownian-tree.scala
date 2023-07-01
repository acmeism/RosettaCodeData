import java.awt.Graphics
import java.awt.image.BufferedImage

import javax.swing.JFrame

import scala.collection.mutable.ListBuffer

object BrownianTree extends App {
  val rand = scala.util.Random

  class BrownianTree extends JFrame("Brownian Tree") with Runnable {
    setBounds(100, 100, 400, 300)
    val img = new BufferedImage(getWidth, getHeight, BufferedImage.TYPE_INT_RGB)

    override def paint(g: Graphics): Unit = g.drawImage(img, 0, 0, this)

    override def run(): Unit = {
      class Particle(var x: Int = rand.nextInt(img.getWidth),
                     var y: Int = rand.nextInt(img.getHeight)) {

        /* returns false if either out of bounds or collided with tree */
        def move: Boolean = {
          val (dx, dy) = (rand.nextInt(3) - 1, rand.nextInt(3) - 1)
          if ((x + dx < 0) || (y + dy < 0) ||
            (y + dy >= img.getHeight) || (x + dx >= img.getWidth)) false
          else {
            x += dx
            y += dy
            if ((img.getRGB(x, y) & 0xff00) == 0xff00) {
              img.setRGB(x - dx, y - dy, 0xff00)
               false
            } else true
          }
        }
      }

      var particles = ListBuffer.fill(20000)(new Particle)
      while (particles.nonEmpty) {
        particles = particles.filter(_.move)
        repaint()
      }
    }

    setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE)
    img.setRGB(img.getWidth / 2, img.getHeight / 2, 0xff00)
    setVisible(true)
  }

  new Thread(new BrownianTree).start()
}
