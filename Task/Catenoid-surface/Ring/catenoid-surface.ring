# Drawing a Catenoid 3D in Ring language
load "freeglut.ring"
load "opengl21lib.ring"

func main
    glutInit()
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
    glutInitWindowSize(800, 600)
    glutCreateWindow("Catenoid 3D - Ring Language")

    glEnable(GL_DEPTH_TEST)
    glClearColor(0.1, 0.1, 0.1, 1.0) # Dark gray background

    # Setup perspective for correct 3D rendering
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluPerspective(45.0, 800/600, 1.0, 10.0)
    glMatrixMode(GL_MODELVIEW)

    glutDisplayFunc(:drawCatenoid)
    glutMainLoop()

func drawCatenoid
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()

    # Move the camera back and rotate it
    glTranslatef(0.0, 0.0, -5.0)
    glRotatef(60, 1, 0.5, 0)
    glScalef(0.5, 0.5, 0.5)

    a = 1.0
    PI = 3.1415926

    # Grid resolution (using integer steps due to Ring limitations)
    u_steps = 40
    v_steps = 40

    glBegin(GL_LINES)

    for i = 0 to u_steps
        # Scale u between -2.0 and +2.0
        u = -2.0 + (i * (4.0 / u_steps))
        u2 = -2.0 + ((i + 1) * (4.0 / u_steps))

        for j = 0 to v_steps
            # Scale v between 0 and 2*PI
            v = j * (2 * PI / v_steps)

            # Parametric equations (With custom cosh function)
            x = a * my_cosh(u) * cos(v)
            y = a * my_cosh(u) * sin(v)
            z = a * u

            # Color gradient based on height
            glColor3f((z + 2)/4, 0.4, 1.0 - (z + 2)/4)
            glVertex3f(x, y, z)

            # Next point for the grid line
            x2 = a * my_cosh(u2) * cos(v)
            y2 = a * my_cosh(u2) * sin(v)
            z2 = a * u2
            glVertex3f(x2, y2, z2)
        next
    next

    glEnd()
    glutSwapBuffers()

# Safe hyperbolic cosine calculation using Ring's ** operator
func my_cosh x
    e = 2.7182818
    return (e**x + e**(-x)) / 2
