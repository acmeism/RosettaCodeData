# Author: Gal Zsolt (CalmoSoft)
load "guilib.ring"
load "stdlibcore.ring"

new qApp {
    win1 = new qWidget() {
        setWindowTitle("Möbius Strip - CalmoSoft")
        resize(600, 600)

        label1 = new qLabel(win1) {
            setFixedSize(600, 600)
            setStyleSheet("background-color: white;")
        }

        show()
        drawMobius()
    }
    exec()
}

func drawMobius
    # Create the canvas
    canvas = new qPixmap2(600, 600)
    canvas.fill(new qColor() { setRGB(255, 255, 255, 255) })

    painter = new qPainter()
    painter.begin(canvas)

    pen = new qPen() {
        setWidth(1)
        setColor(new qColor() { setRGB(255, 0, 0, 255) }) # Red color
    }
    painter.setPen(pen)

    radius = 150
    half_width = 60

    for u = 0 to 360 step 2
        rad_u = u * 3.14159 / 180

        # Inner edge point
        v1 = -half_width
        x1 = (radius + v1 * cos(rad_u / 2)) * cos(rad_u)
        y1 = (radius + v1 * cos(rad_u / 2)) * sin(rad_u)
        z1 = v1 * sin(rad_u / 2)
        px1 = 300 + x1 + (z1 * 0.3)
        py1 = 300 + y1 - (z1 * 0.3)

        # Outer edge point
        v2 = half_width
        x2 = (radius + v2 * cos(rad_u / 2)) * cos(rad_u)
        y2 = (radius + v2 * cos(rad_u / 2)) * sin(rad_u)
        z2 = v2 * sin(rad_u / 2)
        px2 = 300 + x2 + (z2 * 0.3)
        py2 = 300 + y2 - (z2 * 0.3)

        # Draw a red line between the two edges
        painter.drawLine(px1, py1, px2, py2)
    next

    painter.endpaint()
    label1.setPixmap(canvas)
