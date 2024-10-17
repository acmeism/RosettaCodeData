// version 1.1

import java.awt.Color
import java.awt.Graphics
import javax.swing.JFrame

class GreyBars : JFrame("grey bars example!") {
    private val w: Int
    private val h: Int

    init {
        w = 640
        h = 320
        setSize(w, h)
        defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        isVisible = true
    }

    override fun paint(g: Graphics) {
        var run = 0
        var colorComp: Double  // component of the color
        var columnCount = 8
        while (columnCount < 128) {
            var colorGap = 255.0 / (columnCount - 1) // by this gap we change the background color
            val columnWidth = w / columnCount
            val columnHeight = h / 4
            if (run % 2 == 0)  // switches color directions with each iteration of while loop
                colorComp = 0.0
            else {
                colorComp = 255.0
                colorGap *= -1.0
            }
            val ystart = columnHeight * run
            var xstart = 0
            for (i in 0 until columnCount) {
                val iColor = Math.round(colorComp).toInt()
                val nextColor = Color(iColor, iColor, iColor)
                g.color = nextColor
                g.fillRect(xstart, ystart, columnWidth, columnHeight)
                xstart += columnWidth
	        colorComp += colorGap
	    }
            run++
            columnCount *= 2
        }
    }
}

fun main(args: Array<String>) {
    GreyBars()
}
