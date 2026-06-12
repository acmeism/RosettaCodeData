# Author: Gal Zsolt (CalmoSoft)
load "guilib.ring"

import System.GUI

new qApp {
    win = new qWidget() {
        setWindowTitle("Ring GUI - Torus")
        resize(800, 600)

        label = new qLabel(win) {
            setGeometry(0, 0, 800, 600)
            pixmap = new qPixmap2(800, 600)
            pixmap.fill(new qColor() { setrgb(10, 10, 15, 255) })

            painter = new qPainter() {
                begin(pixmap)

                R = 150  # Outer radius
                r = 60   # Inner radius (tube radius)

                # Rotation angles (in radians)
                A = 0.5  # Tilt around X axis
                B = 0.5  # Tilt around Z axis

                for j = 0 to 6.28 step 0.1      # Ring circumference (theta)
                    for i = 0 to 6.28 step 0.04 # Tube circumference (phi)

                        sini = sin(i)  cosi = cos(i)
                        sinj = sin(j)  cosj = cos(j)
                        sinA = sin(A)  cosA = cos(A)
                        sinB = sin(B)  cosB = cos(B)

                        # 3D coordinate calculation
                        h = R + r * cosj
                        x = h * (cosB * cosi + sinA * sinB * sini) - r * cosA * sinB * sinj
                        y = h * (sinB * cosi - sinA * cosB * sini) + r * cosA * cosB * sinj
                        z = h * cosA * sini + r * sinA * sinj

                        # Luminance calculation (dot product with light source)
                        # Light source is coming from top-front
                        luminance = 8 * ((cosj * cosi * sinB - sinA * cosj * sini *
                                    cosB - cosA * sinj * cosB) - cosi * sinj * sinA)

                        if luminance > 0
                            # Set color based on brightness (0-255)
                            bright = floor(luminance * 30)
                            if bright > 255 bright = 255 ok

                            setPen(new qPen() {
                                setcolor(new qColor(){ setrgb(bright/2, bright, 255, 255) })
                            })

                            # Perspective projection to 2D
                            ooz = 1 / (z + 500) # Depth feeling (One Over Z)
                            xp = 400 + x * ooz * 600
                            yp = 300 - y * ooz * 600

                            drawPoint(xp, yp)
                        ok
                    next
                next
                endpaint()
            }
            setpixmap(pixmap)
        }
        show()
    }
    exec()
}
