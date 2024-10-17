// version 1.1.4

import java.awt.BasicStroke
import java.awt.BorderLayout
import java.awt.Color
import java.awt.Dimension
import java.awt.Font
import java.awt.Graphics
import java.awt.Graphics2D
import java.awt.Polygon
import java.awt.RenderingHints
import java.awt.event.KeyAdapter
import java.awt.event.KeyEvent
import java.awt.event.MouseAdapter
import java.awt.event.MouseEvent
import java.awt.event.WindowEvent
import javax.swing.JFrame
import javax.swing.JPanel
import javax.swing.SwingUtilities

class Honeycombs : JPanel() {
    private val comb: Array<Hexagon?> = arrayOfNulls(20)

    init {
        preferredSize = Dimension(600, 500)
        background = Color.white
        isFocusable = true

        addMouseListener(object : MouseAdapter() {
            override fun mousePressed(e: MouseEvent) {
                for (hex in comb)
                    if (hex!!.contains(e.x, e.y)) {
                        hex.setSelected()
                        checkForClosure()
                        break
                    }
                repaint()
            }
        })

        addKeyListener(object : KeyAdapter() {
            override fun keyPressed(e: KeyEvent) {
                for (hex in comb)
                    if (hex!!.letter == e.keyChar.toUpperCase()) {
                        hex.setSelected()
                        checkForClosure()
                        break
                    }
                repaint()
            }
        })

        val letters = "LRDGITPFBVOKANUYCESM".toCharArray()
        val x1 = 150
        val y1 = 100
        val x2 = 225
        val y2 = 143
        val w = 150
        val h = 87

        for (i in 0 until comb.size) {
            var x: Int
            var y: Int
            if (i < 12) {
                x = x1 + (i % 3) * w
                y = y1 + (i / 3) * h
            }
            else {
                x = x2 + (i % 2) * w
                y = y2 + ((i - 12) / 2) * h
            }
            comb[i] = Hexagon(x, y, w / 3, letters[i])
        }

        requestFocus()
    }

    override fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                           RenderingHints.VALUE_ANTIALIAS_ON)
        g.font = Font("SansSerif", Font.BOLD, 30)
        g.stroke = BasicStroke(3.0f)
        for (hex in comb) hex!!.draw(g)
    }

    private fun checkForClosure() {
        if (comb.all { it!!.hasBeenSelected } ) {
            val f = SwingUtilities.getWindowAncestor(this) as JFrame
            f.dispatchEvent(WindowEvent(f, WindowEvent.WINDOW_CLOSING))
        }
    }
}

class Hexagon(x: Int, y: Int, halfWidth: Int, c: Char) : Polygon() {
    private val baseColor = Color.yellow
    private val selectedColor = Color.magenta
    var hasBeenSelected = false
    val letter = c

    init {
        for (i in 0..5)
            addPoint((x + halfWidth * Math.cos(i * Math.PI / 3.0)).toInt(),
                     (y + halfWidth * Math.sin(i * Math.PI / 3.0)).toInt())
        getBounds()
    }

    fun setSelected() {
        hasBeenSelected = true
    }

    fun draw(g: Graphics2D) {
        with(g) {
            color = if (hasBeenSelected) selectedColor else baseColor
            fillPolygon(this@Hexagon)
            color = Color.black
            drawPolygon(this@Hexagon)
            color = if (hasBeenSelected) Color.black else Color.red
            drawCenteredString(g, letter.toString())
        }
    }

    private fun drawCenteredString(g: Graphics2D, s: String) {
        val fm = g.fontMetrics
        val asc = fm.ascent
        val dec = fm.descent
        val x = bounds.x + (bounds.width - fm.stringWidth(s)) / 2
        val y = bounds.y + (asc + (bounds.height - (asc + dec)) / 2)
        g.drawString(s, x, y)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        with(f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            add(Honeycombs(), BorderLayout.CENTER)
            title = "Honeycombs"
            isResizable = false
            pack()
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}
