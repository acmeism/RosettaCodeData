// Version 1.2.31

import org.jfree.chart.ChartFactory
import org.jfree.chart.ChartPanel
import org.jfree.data.xy.XYSeries
import org.jfree.data.xy.XYSeriesCollection
import org.jfree.chart.plot.PlotOrientation
import javax.swing.JFrame
import javax.swing.SwingUtilities
import java.awt.BorderLayout

fun main(args: Array<String>) {
    val x = intArrayOf(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
    val y = doubleArrayOf(
        2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0
    )
    val series = XYSeries("plots")
    (0 until x.size).forEach { series.add(x[it], y[it]) }
    val labels = arrayOf("Plot Demo", "X", "Y")
    val data = XYSeriesCollection(series)
    val options = booleanArrayOf(false, true, false)
    val orient = PlotOrientation.VERTICAL
    val chart = ChartFactory.createXYLineChart(
        labels[0], labels[1], labels[2], data, orient, options[0], options[1], options[2]
    )
    val chartPanel = ChartPanel(chart)
    SwingUtilities.invokeLater {
        val f = JFrame()
        with(f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            add(chartPanel, BorderLayout.CENTER)
            title = "Plot coordinate pairs"
            isResizable = false
            pack()
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}
