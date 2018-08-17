import java.awt._
import java.awt.event.{MouseAdapter, MouseEvent}

import javax.swing._

import scala.math.{Pi, cos, sin}

object Cuboid extends App {
  SwingUtilities.invokeLater(() => {

    class Cuboid extends JPanel {
      private val nodes: Array[Array[Double]] =
        Array(Array(-1, -1, -1), Array(-1, -1, 1), Array(-1, 1, -1), Array(-1, 1, 1),
          Array(1, -1, -1), Array(1, -1, 1), Array(1, 1, -1), Array(1, 1, 1))
      private var mouseX, prevMouseX, mouseY, prevMouseY: Int = _

      private def edges =
        Seq(Seq(0, 1), Seq(1, 3), Seq(3, 2), Seq(2, 0),
          Seq(4, 5), Seq(5, 7), Seq(7, 6), Seq(6, 4),
          Seq(0, 4), Seq(1, 5), Seq(2, 6), Seq(3, 7))

      override def paintComponent(gg: Graphics): Unit = {
        val g = gg.asInstanceOf[Graphics2D]

        def drawCube(g: Graphics2D): Unit = {
          g.translate(getWidth / 2, getHeight / 2)
          for (edge <- edges) {
            g.drawLine(nodes(edge.head)(0).round.toInt, nodes(edge.head)(1).round.toInt,
              nodes(edge(1))(0).round.toInt, nodes(edge(1))(1).round.toInt)
          }
          for (node <- nodes) g.fillOval(node(0).round.toInt - 4, node(1).round.toInt - 4, 8, 8)
        }

        super.paintComponent(gg)
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        drawCube(g)
      }

      private def scale(sx: Double, sy: Double, sz: Double): Unit = {
        for (node <- nodes) {
          node(0) *= sx
          node(1) *= sy
          node(2) *= sz
        }
      }

      private def rotateCube(angleX: Double, angleY: Double): Unit = {
        val (sinX, cosX, sinY, cosY) = (sin(angleX), cos(angleX), sin(angleY), cos(angleY))
        for (node <- nodes) {
          val (x, y, z) = (node.head, node(1), node(2))
          node(0) = x * cosX - z * sinX
          node(2) = z * cosX + x * sinX
          node(1) = y * cosY - node(2) * sinY
          node(2) = node(2) * cosY + y * sinY
        }
      }

      addMouseListener(new MouseAdapter() {
        override def mousePressed(e: MouseEvent): Unit = {
          mouseX = e.getX
          mouseY = e.getY
        }
      })

      addMouseMotionListener(new MouseAdapter() {
        override def mouseDragged(e: MouseEvent): Unit = {
          prevMouseX = mouseX
          prevMouseY = mouseY
          mouseX = e.getX
          mouseY = e.getY
          rotateCube((mouseX - prevMouseX) * 0.01, (mouseY - prevMouseY) * 0.01)
          repaint()
        }
      })

      scale(80, 120, 160)
      rotateCube(Pi / 5, Pi / 9)
      setPreferredSize(new Dimension(640, 640))
      setBackground(Color.white)
    }

    new JFrame("Cuboid") {
      add(new Cuboid, BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setResizable(false)
      setVisible(true)
    }
  })
}
