// Kotlin Native v0.6

import kotlinx.cinterop.*
import opengl.*

var rot = 0f
val matCol = floatArrayOf(1f, 0f, 0f, 0f)

fun display() {
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
    glPushMatrix()
    glRotatef(30f, 1f, 1f, 0f)
    glRotatef(rot, 0f, 1f, 1f)
    glMaterialfv(GL_FRONT, GL_DIFFUSE, matCol.toCValues())
    glutWireTeapot(0.5)
    glPopMatrix()
    glFlush()
}

fun onIdle() {
    rot += 0.1f
    glutPostRedisplay()
}

fun init() {
    val white = floatArrayOf(1f, 1f, 1f, 0f)
    val shini = floatArrayOf(70f)
    glClearColor(0.5f, 0.5f, 0.5f, 0f);
    glShadeModel(GL_SMOOTH)
    glLightfv(GL_LIGHT0, GL_AMBIENT, white.toCValues())
    glLightfv(GL_LIGHT0, GL_DIFFUSE, white.toCValues())
    glMaterialfv(GL_FRONT, GL_SHININESS, shini.toCValues())
    glEnable(GL_LIGHTING)
    glEnable(GL_LIGHT0)
    glEnable(GL_DEPTH_TEST)
}

fun main(args: Array<String>) {
    memScoped {
        val argc = alloc<IntVar>().apply { value = 0 }
        glutInit(argc.ptr, null)
    }
    glutInitDisplayMode(GLUT_SINGLE or GLUT_RGB or GLUT_DEPTH)
    glutInitWindowSize(900, 700)
    val title = "The Amazing, Rotating Utah Teapot brought to you in OpenGL via freeglut."
    glutCreateWindow(title)
    init()
    glutDisplayFunc(staticCFunction(::display))
    glutIdleFunc(staticCFunction(::onIdle))
    glutMainLoop()
}
