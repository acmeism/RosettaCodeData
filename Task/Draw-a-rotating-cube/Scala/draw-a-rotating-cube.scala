import java.awt.event.ActionEvent
import java.awt._

import javax.swing.{JFrame, JPanel, Timer}

import scala.math.{Pi, atan, cos, sin, sqrt}

object RotatingCube extends App {

  class RotatingCube extends JPanel {
    private val vertices: Vector[Array[Double]] =
      Vector(Array(-1, -1, -1), Array(-1, -1, 1), Array(-1, 1, -1),
        Array(-1, 1, 1), Array(1, -1, -1), Array(1, -1, 1), Array(1, 1, -1), Array(1, 1, 1))

    private val edges: Vector[(Int, Int)] =
      Vector((0, 1), (1, 3), (3, 2), (2, 0), (4, 5), (5, 7),
        (7, 6), (6, 4), (0, 4), (1, 5), (2, 6), (3, 7))

    setPreferredSize(new Dimension(640, 640))
    setBackground(Color.white)
    scale(100)
    rotateCube(Pi / 4, atan(sqrt(2)))

    new Timer(17, (_: ActionEvent) => {
      rotateCube(Pi / 180, 0)
      repaint()
    }).start()

    override def paintComponent(gg: Graphics): Unit = {
      def drawCube(g: Graphics2D): Unit = {
        g.translate(getWidth / 2, getHeight / 2)
        for {edge <- edges
             xy1: Array[Double] = vertices(edge._1)
             xy2: Array[Double] = vertices(edge._2)
             } {
          g.drawLine(xy1(0).toInt, xy1(1).toInt, xy2(0).toInt, xy2(1).toInt)
          g.fillOval(xy1(0).toInt -4, xy1(1).toInt - 4, 8, 8)
          g.setColor(Color.black)
        }
      }

      super.paintComponent(gg)
      val g: Graphics2D = gg.asInstanceOf[Graphics2D]
      g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
      drawCube(g)
    }

    private def scale(s: Double): Unit = {
      for {node <- vertices
           i <- node.indices
           } node(i) *= s
    }

    private def rotateCube(angleX: Double, angleY: Double): Unit = {
      def sinCos(x: Double) = (sin(x), cos(x))

      val ((sinX, cosX), (sinY, cosY)) = (sinCos(angleX), sinCos(angleY))

      for {
        node <- vertices
        x: Double = node(0)
        y: Double = node(1)
      } {
        def f(p: Double, q: Double)(a: Double, b: Double) = a * p + b * q

        def fx(a: Double, b: Double) = f(cosX, sinX)(a, b)

        def fy(a: Double, b: Double) = f(cosY, sinY)(a, b)

        node(0) = fx(x, -node(2))
        val z = fx(node(2), x)
        node(1) = fy(y, -z)
        node(2) = fy(z, y)
      }
    }

  }

  new JFrame("Rotating Cube") {
    add(new RotatingCube(), BorderLayout.CENTER)
    pack()
    setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE)
    setLocationRelativeTo(null)
    setResizable(false)
    setVisible(true)
  }

}
