# Author: Gal Zsolt (CalmoSoft)
load "guilib.ring"

new qApp {
    win1 = new qWidget() {
        setwindowtitle("Diamond - CalmoSoft")
        setgeometry(100,100,600,600)

        canvas = new qLabel(win1) { setgeometry(0,0,600,600) }

        pixmap = new qPixmap2(600,600)

        # Set white background
        color = new qColor() { setrgb(255,255,255,255) }
        pixmap.fill(color)

        painter = new qPainter() {
            begin(pixmap)

            # Pen settings (Blue, 3 pixels wide)
            pen = new qPen() {
                setcolor(new qColor() { setrgb(0,120,255,255) })
                setwidth(3)
            }
            setpen(pen)

            # MATHEMATICAL CENTER (600 / 2 = 300)
            cx = 300
            y1 = 150   # Top edge
            y2 = 230   # Wide part
            y3 = 450   # Bottom tip

            # Symmetrical drawing around the cx (300) axis
            drawline(cx - 80, y1, cx + 80, y1)   # Top
            drawline(cx + 80, y1, cx + 160, y2)  # Upper right
            drawline(cx + 160, y2, cx, y3)       # Lower right
            drawline(cx, y3, cx - 160, y2)       # Lower left
            drawline(cx - 160, y2, cx - 80, y1)  # Upper left

            # Inner edges (facets) aligned to the 300 center line
            drawline(cx - 160, y2, cx + 160, y2) # Girdle line
            drawline(cx - 80, y1, cx, y3)        # Inner left diagonal
            drawline(cx + 80, y1, cx, y3)        # Inner right diagonal

            endpaint()
        }

        canvas.setpixmap(pixmap)
        show()
    }
    exec()
}
