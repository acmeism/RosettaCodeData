import java.awt.Color
import java.util.concurrent.{Executors, TimeUnit}

import scala.swing.{Graphics2D, MainFrame, Panel, SimpleSwingApplication}
import scala.swing.Swing.pair2Dimension

object Pendulum extends SimpleSwingApplication {
  val length = 100

  lazy val ui = new Panel {
    import scala.math.{cos, Pi, sin}

    background = Color.white
    preferredSize = (2 * length + 50, length / 2 * 3)
    peer.setDoubleBuffered(true)

    var angle: Double = Pi / 2

    override def paintComponent(g: Graphics2D): Unit = {
      super.paintComponent(g)

      val (anchorX, anchorY) = (size.width / 2, size.height / 4)
      val (ballX, ballY) =
        (anchorX + (sin(angle) * length).toInt, anchorY + (cos(angle) * length).toInt)
      g.setColor(Color.lightGray)
      g.drawLine(anchorX - 2 * length, anchorY, anchorX + 2 * length, anchorY)
      g.setColor(Color.black)
      g.drawLine(anchorX, anchorY, ballX, ballY)
      g.fillOval(anchorX - 3, anchorY - 4, 7, 7)
      g.drawOval(ballX - 7, ballY - 7, 14, 14)
      g.setColor(Color.yellow)
      g.fillOval(ballX - 7, ballY - 7, 14, 14)
    }

    val animate: Runnable = new Runnable {
      var angleVelocity = 0.0
      var dt = 0.1

      override def run(): Unit = {
        angleVelocity += -9.81 / length * Math.sin(angle) * dt
        angle += angleVelocity * dt
        repaint()
      }
    }
  }

  override def top = new MainFrame {
    title = "Rosetta Code >>> Task: Animate a pendulum | Language: Scala"
    contents = ui
    centerOnScreen()
    Executors.
      newSingleThreadScheduledExecutor().
      scheduleAtFixedRate(ui.animate, 0, 15, TimeUnit.MILLISECONDS)
  }
}
