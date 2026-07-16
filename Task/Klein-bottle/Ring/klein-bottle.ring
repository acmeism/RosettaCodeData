load "guilib.ring"

new qApp {
    # 1. Initialize main window
    win1 = new qWidget() {
        setwindowtitle("True Classic Klein Bottle GUI - Ring")
        setgeometry(100, 100, 900, 700)

        # 2. Virtual canvas (Picture)
        canvas = new qPicture()
        painter = new qPainter() {
            begin(canvas)

            # Fill background with dark navy/black
            bgColor = new qColor() { setrgb(10, 10, 15, 255) }
            bgBrush = new qBrush() {
                setstyle(1)
                setcolor(bgColor)
            }
            setbrush(bgBrush)
            drawrect(0, 0, 900, 700)

            # Set pen for the 3D mesh (Neon cyan)
            pen1 = new qPen()
            pen1.setcolor(new qColor() { setrgb(0, 229, 255, 120) }) # Slight transparency for depth effect
            pen1.setwidth(1)
            setpen(pen1)

            # Resolution parameters for the true shape
            steps_u = 50
            steps_v = 40
            pi = 3.14159265

            # 2D arrays to store screen coordinates for drawing grid lines
            # In Ring, lists are dynamic; we pre-initialize the rows
            points_x = list(steps_u + 1)
            points_y = list(steps_u + 1)
            for i = 1 to steps_u + 1
                points_x[i] = list(steps_v + 1)
                points_y[i] = list(steps_v + 1)
            next

            # --- STEP 1: Calculate mathematical points and project them ---
            for u = 0 to steps_u
                u_val = (u / steps_u) * 2 * pi  # True range: from 0 to 2pi
                for v = 0 to steps_v
                    v_val = (v / steps_v) * 2 * pi

                    # Classical "bottle" Klein bottle equations (Stewart Dickson / Mathworld formula)
                    if u_val < pi
                        x = 6 * cos(u_val) * (1 + sin(u_val)) + (4 * (1 - cos(u_val) / 2)) * cos(u_val) * cos(v_val)
                        z = 16 * sin(u_val) + (4 * (1 - cos(u_val) / 2)) * sin(u_val) * cos(v_val)
                    else
                        x = 6 * cos(u_val) * (1 + sin(u_val)) + (4 * (1 - cos(u_val) / 2)) * cos(v_val + pi)
                        z = 16 * sin(u_val)
                    ok
                    y = (4 * (1 - cos(u_val) / 2)) * sin(v_val)

                    # 3D -> 2D Projection (with 30-degree rotation around Y and Z axes for better depth)
                    cos_a = 0.866 # cos(30)
                    sin_a = 0.500 # sin(30)

                    # Rotated coordinates
                    x_rot = x * cos_a - y * sin_a
                    y_rot = x * sin_a + y * cos_a
                    z_rot = z

                    # Scale and translate to the center of the 900x700 window
                    scale = 17
                    screen_x = 450 + (x_rot - y_rot * 0.3) * scale
                    screen_y = 400 - (z_rot - y_rot * 0.2) * scale

                    # Save for wireframe drawing (1-based indexing in Ring)
                    points_x[u+1][v+1] = screen_x
                    points_y[u+1][v+1] = screen_y
                next
            next

            # --- STEP 2: Connect the 3D wireframe mesh ---
            for u = 1 to steps_u
                for v = 1 to steps_v
                    # Line to adjacent V point (U lines)
                    drawline(points_x[u][v], points_y[u][v], points_x[u][v+1], points_y[u][v+1])
                    # Line to adjacent U point (V lines)
                    drawline(points_x[u][v], points_y[u][v], points_x[u+1][v], points_y[u+1][v])
                next
            next

            endpaint()
        }

        # 3. Display using a Label component
        label1 = new qLabel(win1) {
            setgeometry(0, 0, 900, 700)
            setpicture(canvas)
        }

        show()
    }
    exec()
}
