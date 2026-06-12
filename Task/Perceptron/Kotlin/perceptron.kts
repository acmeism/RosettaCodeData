// version 1.1.4-3

import java.awt.*
import java.awt.event.ActionEvent
import java.util.Random
import javax.swing.JPanel
import javax.swing.JFrame
import javax.swing.Timer
import javax.swing.SwingUtilities

class Perceptron(n: Int) : JPanel() {

    class Trainer(x: Double, y: Double, val answer: Int) {
        val inputs = doubleArrayOf(x, y, 1.0)
    }

    val weights: DoubleArray
    val training: Array<Trainer>
    val c = 0.00001
    var count = 0

    init {
        val r = Random()
        val dim = Dimension(640, 360)
        preferredSize = dim
        background = Color.white
        weights = DoubleArray(n) { r.nextDouble() * 2.0 - 1.0 }
        training = Array(2000) {
            val x = r.nextDouble() * dim.width
            val y = r.nextDouble() * dim.height
            val answer = if (y < f(x)) -1 else 1
            Trainer(x, y, answer)
        }
        Timer(10) { repaint() }.start()
    }

    private fun f(x: Double) = x * 0.7 + 40.0

    fun feedForward(inputs: DoubleArray): Int {
        if (inputs.size != weights.size)
            throw IllegalArgumentException("Weights and input length mismatch")
        val sum = weights.zip(inputs) { w, i -> w * i }.sum()
        return activate(sum)
    }

    fun activate(s: Double) = if (s > 0.0) 1 else -1

    fun train(inputs: DoubleArray, desired: Int) {
        val guess = feedForward(inputs)
        val error = desired - guess
        for (i in 0 until weights.size) weights[i] += c * error * inputs[i]
    }

    public override fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                           RenderingHints.VALUE_ANTIALIAS_ON)

        // we're drawing upside down
        var x = width
        var y = f(x.toDouble()).toInt()
        g.stroke = BasicStroke(2.0f)
        g.color = Color.orange
        g.drawLine(0, f(0.0).toInt(), x, y)

        train(training[count].inputs, training[count].answer)
        count = (count + 1) % training.size

        g.stroke = BasicStroke(1.0f)
        g.color = Color.black
        for (i in 0 until count) {
            val guess = feedForward(training[i].inputs)
            x = training[i].inputs[0].toInt() - 4
            y = training[i].inputs[1].toInt() - 4
            if (guess > 0) g.drawOval(x, y, 8, 8)
            else g.fillOval(x, y, 8, 8)
        }
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        with(f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            title = "Perceptron"
            isResizable = false
            add(Perceptron(3), BorderLayout.CENTER)
            pack()
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}
