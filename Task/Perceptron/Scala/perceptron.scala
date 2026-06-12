import java.awt._
import java.awt.event.ActionEvent

import javax.swing._

import scala.util.Random

object Perceptron extends App {
  SwingUtilities.invokeLater(() =>

    new JFrame("Perceptron") {

      class Perceptron(val n: Int) extends JPanel {
        private val (c, dim) = (0.00001, new Dimension(640, 360))
        private val (random, training) = (new Random, Array.ofDim[Trainer](2000))
        private val weights = Array.fill(n)(random.nextDouble * 2 - 1)
        private var count = 0

        override def paintComponent(gg: Graphics): Unit = {
          var x = getWidth
          var y = f(x).toInt

          def train(inputs: Array[Double], desired: Int): Unit = {
            val guess = feedForward(inputs)
            for (i <- weights.indices) weights(i) += c * (desired - guess) * inputs(i)
          }

          def feedForward(inputs: Array[Double]) = {
            assert(inputs.length == weights.length, "weights and input length mismatch")
            var sum = 0.0
            for (i <- weights.indices) {
              sum += inputs(i) * weights(i)
            }
            if (sum > 0) 1 else -1
          }

          super.paintComponent(gg)
          val g = gg.asInstanceOf[Graphics2D]
          g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
          // we're drawing upside down
          g.setStroke(new BasicStroke(2))
          g.setColor(Color.orange)
          g.drawLine(0, f(0).toInt, x, y)
          train(training(count).inputs, training(count).answer)
          count = (count + 1) % training.length
          g.setStroke(new BasicStroke(1))
          g.setColor(Color.black)
          for (i <- 0 until count) {
            val guess = feedForward(training(i).inputs)
            x = training(i).inputs(0).toInt - 4
            y = training(i).inputs(1).toInt - 4
            if (guess > 0) g.drawOval(x, y, 8, 8)
            else g.fillOval(x, y, 8, 8)
          }
        }

        private def f(x: Double) = x * 0.7 + 40

        class Trainer(val x: Double, val y: Double, var answer: Int) {
          val inputs = Array[Double](x, y, 1)
        }

        for (j <- training.indices;
             x = random.nextDouble * dim.width;
             y = random.nextDouble * dim.height;
             answer = if (y < f(x)) -1 else 1
        ) training(j) = new Trainer(x, y, answer)

        new Timer(10, (e: ActionEvent) => repaint()).start()

        setBackground(Color.white)
        setPreferredSize(dim)
      }

      add(new Perceptron(3), BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setResizable(false)
      setVisible(true)
    })

}
