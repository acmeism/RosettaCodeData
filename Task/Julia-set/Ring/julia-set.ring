# Author: Gal Zsolt (CalmoSoft)
load "guilib.ring"

see "Working..." + nl

p1 = null

new qapp {
    win1 = new qwidget() {
        setwindowtitle("Julia Set - CalmoSoft")
        setgeometry(100,100,600,600)

        lbl = new qlabel(win1) {
            setgeometry(0,0,600,600)
            setstylesheet("background-color: black;")
        }

        # Create a 600x600 image
        p1 = new qpixmap2(600,600)
        p1.fill(new qcolor() { setrgb(0,0,0,255) })

        painter = new qpainter() {
            begin(p1)
            # Use a nice cyan color for the fractal
            setpen(new qpen() {
                setcolor(new qcolor() { setrgb(0,255,255,255) })
                setwidth(1)
            })

            creal = -0.8
            cimag = 0.156

            # Loop through all 600x600 pixels
            # Note: If it's slow, change 'step 1' to 'step 2'!
            for py = 0 to 599 step 1
                for px = 0 to 599 step 1
                    # Scaling for 600 pixels: (px - center) / (zoom)
                    x = (px - 300) / 200
                    y = (py - 300) / 200

                    flag = 1
                    for i = 1 to 40 # Iteration count for details
                        nx = x*x - y*y + creal
                        ny = 2*x*y + cimag
                        x = nx
                        y = ny
                        if (x*x + y*y) > 4 flag = 0 exit ok
                    next

                    if flag = 1
                        drawpoint(px, py)
                    ok
                next
            next
            endpaint()
        }

        lbl.setpixmap(p1)
        show()
    }
    see "Done..."
    exec()
}
