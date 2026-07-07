load "guilib.ring"

# Mathematical parameters of the Lorenz attractor
sigma  = 10.0
rho    = 28.0
beta   = 8.0 / 3.0

# Starting position and time step
x = 0.01   y = 0.0   z = 0.0
dt = 0.01

# Screen and zoom settings
scale    = 7.0
offset_x = 400
offset_y = 300

# List of points to draw
points = []

# Initialize an application
app = new qApp {

    win = new qWidget() {
        setwindowtitle("Lorenz Attraktor - RingQt")
        resize(800, 600)

        # The interface where the image is projected
        canvas = new qLabel(win) {
            setgeometry(0, 0, 800, 600)
        }

        # Timer for continuous physical calculation and update
        timer = new qTimer(win) {
            setinterval(16) # ~60 FPS frissítés
            settimeoutevent("update_and_draw_lorenz()")
            start()
        }

        show()
    }

    exec()
}

# Calculate math steps and instantly rerender them
func update_and_draw_lorenz
    # 1. Fizika számítása
    dx = (sigma * (y - x)) * dt
    dy = (x * (rho - z) - y) * dt
    dz = (x * y - beta * z) * dt

    x += dx
    y += dy
    z += dz

    # Scale point to screen
    screen_x = x * scale + offset_x
    screen_y = y * scale + offset_y

    add(points, [screen_x, screen_y])

    # Memory protection: a maximum of 2000 points are stored to avoid stuttering
    if len(points) > 2000
        del(points, 1)
    ok

    # 2. Drawing with qPicture and qPainter
    p1 = new qPicture()

    pen = new qPen() {
        color = new qColor() { setrgb(0, 200, 255, 255) } # Ciánkék vonal
        setcolor(color)
        setwidth(1)
    }

    # Start Image Build
    painter = new qPainter() {
        begin(p1)
        setpen(pen)

        # Draw lines between all the coordinates stored so far with explicit indexing
        if len(points) > 1
            for i = 1 to len(points) - 1
                # Draw lines between all the coordinates stored so far with explicit indexing
                x1 = points[i][1]
                y1 = points[i][2]
                x2 = points[i+1][1]
                y2 = points[i+1][2]

                # The call to Qt4/Qt5/Qt6 qpainter_drawline(int, int, int, int) now gets the correct type
                drawline(x1, y1, x2, y2)
            next
        ok

        endpaint()
    }

    # Pass the drawn image to the Label for display
    canvas {
        setpicture(p1)
        show()
    }

