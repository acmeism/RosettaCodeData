import java.awt._
import java.awt.event.ActionEvent
import java.awt.geom.Path2D

import javax.swing._

import scala.annotation.tailrec
import scala.math.{Pi, cos, sin, sqrt}

object SierpinskiPentagon extends App {
  SwingUtilities.invokeLater(() => {

    class SierpinskiPentagon extends JPanel {

      /* Try to avoid random color values clumping together */

      private var hue = math.random

      // exterior angle
      private val deg072 = 2 * Pi / 5d //toRadians(72)
      /* After scaling we'll have 2 sides plus a gap occupying the length
         of a side before scaling. The gap is the base of an isosceles triangle
         with a base angle of 72 degrees. */
      //private val scaleFactor = 1 / (2 + cos(deg072) * 2)
      private var limit = 0

      private def drawPentagon(g: Graphics2D, x: Double, y: Double, side: Double, depth: Int): Unit = {
        val scaleFactor = 1 / (2 + cos(deg072) * 2)

        if (depth == 0) {
          // draw from the top
          @tailrec
          def iter0(i: Int, x: Double, y: Double, angle: Double, p: Path2D.Double): Path2D.Double = {
            if (i < 0) p
            else {
              p.lineTo(x, y)
              iter0(i - 1, x + cos(angle) * side, y - sin(angle) * side, angle + deg072, p)
            }
          }

          def p1: Path2D.Double = iter0(4, x, y, 3 * deg072, {
            val p = new Path2D.Double
            p.moveTo(x, y)
            p
          })

          def p: Path2D.Double = iter0(4, x, y, 3 * deg072, p1)

          def next: Color = {
            hue = (hue + (sqrt(5) - 1) / 2) % 1
            Color.getHSBColor(hue.toFloat, 1, 1)
          }

          g.setColor(next)
          g.fill(p)
        }
        else {
          val _side = side * scaleFactor
          /* Starting at the top of the highest pentagon, calculate
             the top vertices of the other pentagons by taking the
             length of the scaled side plus the length of the gap. */
          val distance = _side + _side * cos(deg072) * 2
          /* The top positions form a virtual pentagon of their own,
             so simply move from one to the other by changing direction. */

          def iter1(i: Int, x: Double, y: Double, angle: Double): Unit = {
            if (i < 0) ()
            else {
              drawPentagon(g, x, y, _side, depth - 1)
              iter1(i - 1, x + cos(angle) * distance, y - sin(angle) * distance, angle + deg072)
            }
          }

          iter1(4, x + cos(3 * deg072) * distance, y - sin(3 * deg072) * distance, 4 * deg072)
        }
      }

      override def paintComponent(gg: Graphics): Unit = {
        val (g, margin) = (gg.asInstanceOf[Graphics2D], 20)
        val side = (getWidth / 2 - 2 * margin) * sin(Pi / 5) * 2

        super.paintComponent(gg)
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        drawPentagon(g, getWidth / 2, 3 * margin, side, limit)
      }

      new Timer(3000, (_: ActionEvent) => {
        limit += 1
        if (limit >= 5) limit = 0
        repaint()
      }).start()

      setPreferredSize(new Dimension(640, 640))
      setBackground(Color.white)
    }

    val f = new JFrame("Sierpinski Pentagon") {
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setResizable(true)
      add(new SierpinskiPentagon, BorderLayout.CENTER)
      pack()
      setLocationRelativeTo(null)
      setVisible(true)
    }
  })

}
