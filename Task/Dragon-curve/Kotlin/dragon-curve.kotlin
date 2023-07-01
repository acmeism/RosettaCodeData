// version 1.0.6

import java.awt.Color
import java.awt.Graphics
import javax.swing.JFrame

class DragonCurve(iter: Int) : JFrame("Dragon Curve") {
    private val turns: MutableList<Int>
    private val startingAngle: Double
    private val side: Double

    init {
        setBounds(100, 100, 800, 600)
        defaultCloseOperation = EXIT_ON_CLOSE
        turns = getSequence(iter)
        startingAngle = -iter * Math.PI / 4
        side = 400.0 / Math.pow(2.0, iter / 2.0)
    }

    fun getSequence(iterations: Int): MutableList<Int> {
        val turnSequence = mutableListOf<Int>()
        for (i in 0 until iterations) {
            val copy = mutableListOf<Int>()
            copy.addAll(turnSequence)
            copy.reverse()
            turnSequence.add(1)
            copy.mapTo(turnSequence) { -it }
        }
        return turnSequence
    }

    override fun paint(g: Graphics) {
        g.color = Color.BLUE
        var angle = startingAngle
        var x1 = 230
        var y1 = 350
        var x2 = x1 + (Math.cos(angle) * side).toInt()
        var y2 = y1 + (Math.sin(angle) * side).toInt()
        g.drawLine(x1, y1, x2, y2)
        x1 = x2
        y1 = y2
        for (turn in turns) {
            angle += turn * Math.PI / 2.0
            x2 = x1 + (Math.cos(angle) * side).toInt()
            y2 = y1 + (Math.sin(angle) * side).toInt()
            g.drawLine(x1, y1, x2, y2)
            x1 = x2
            y1 = y2
        }
    }
}

fun main(args: Array<String>) {
    DragonCurve(14).isVisible = true
}
