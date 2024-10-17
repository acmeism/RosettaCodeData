// Kotlin Native version 0.3

import kotlinx.cinterop.*
import opengl.*

fun paint() {
    glClearColor(0.3f, 0.3f, 0.3f, 0.0f)
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

    glShadeModel(GL_SMOOTH)

    glLoadIdentity()
    glTranslatef(-15.0f, -15.0f, 0.0f)

    glBegin(GL_TRIANGLES)
    glColor3f(1.0f, 0.0f, 0.0f)
    glVertex2f(0.0f, 0.0f)
    glColor3f(0.0f, 1.0f, 0.0f)
    glVertex2f(30.0f, 0.0f)
    glColor3f(0.0f, 0.0f, 1.0f)
    glVertex2f(0.0f, 30.0f)
    glEnd()

    glFlush()
}

fun reshape(width: Int, height: Int) {
    glViewport(0, 0, width, height)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glOrtho(-30.0, 30.0, -30.0, 30.0, -30.0, 30.0)
    glMatrixMode(GL_MODELVIEW)
}

fun main(args: Array<String>) {
    memScoped {
        val argc = alloc<IntVar>().apply { value = 0 }
        glutInit(argc.ptr, null)
    }

    glutInitWindowSize(640, 480)
    glutCreateWindow("Triangle")

    glutDisplayFunc(staticCFunction(::paint))
    glutReshapeFunc(staticCFunction(::reshape))

    glutMainLoop()
}
