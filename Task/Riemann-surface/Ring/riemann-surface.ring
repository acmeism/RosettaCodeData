load "guilib.ring"

# Global variables for rotation and scaling
angle_y = 0.5
angle_x = 0.6
scale   = 160
WIDTH   = 800
HEIGHT  = 600

app = new qApp {
    win = new qWidget() {
        setwindowtitle("Riemann Surface - White Background")
        resize(WIDTH, HEIGHT)

        # Create a custom drawing widget
        label = new qLabel(win) {
            resize(WIDTH, HEIGHT)
        }

        # Timer for the rotation animation
        timer = new qTimer(win) {
            setinterval(30)
            settimeoutevent("drawSurface()")
            start()
        }
        show()
    }
    drawSurface()
    exec()
}

func drawSurface
    # Initialize image and canvas objects
    pixmap = new qPixmap2(WIDTH, HEIGHT)
    pixmap.fill(new qColor() { setrgb(255, 255, 255, 255) }) # WHITE BACKGROUND

    painter = new qPainter() {
        begin(pixmap)
        setRenderHint(1, true) # Enable anti-aliasing
    }

    r_steps = 15
    t_steps = 70
    pi = 3.14159265

    # Calculate and project mathematical surface points
    for r_idx = 1 to r_steps
        r = (r_idx / r_steps) * 1.8

        for t_idx = 1 to t_steps
            theta = (t_idx / t_steps) * 4.0 * pi

            # Equation of the f(z) = sqrt(z) Riemann surface
            x = r * cos(theta)
            y = r * sin(theta)
            z = sqrt(r) * cos(theta / 2)

            # 3D Rotation around the Y axis
            x1 = x * cos(angle_y) - z * sin(angle_y)
            z1 = x * sin(angle_y) + z * cos(angle_y)

            # 3D Rotation around the X axis
            y1 = y * cos(angle_x) - z1 * sin(angle_x)

            # Orthographic projection to 2D screen coordinates
            screen_x = WIDTH / 2 + x1 * scale
            screen_y = HEIGHT / 2 - y1 * scale

            # Coloring based on height (Z) - Dark Blue to Purple to Dark Red gradient for white background
            color_val = floor((z + 1.4) * 85)
            if color_val > 255 color_val = 255 ok
            if color_val < 0   color_val = 0   ok

            pen = new qPen() {
                # Stronger colors to make them stand out on the white background
                setcolor(new qColor() { setrgb(color_val, 20, 200 - color_val, 255) })
                setwidth(4) # Slightly thicker points for better visibility
            }
            painter.setPen(pen)

            # Draw point
            painter.drawPoint(screen_x, screen_y)
        next
    next

    # Finalize drawing and update the image on the widget
    painter.end()
    label.setpixmap(pixmap)

    # Increase the angle for the next frame's rotation
    angle_y = angle_y + 0.02
