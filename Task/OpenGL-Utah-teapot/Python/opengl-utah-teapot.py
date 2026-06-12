from OpenGL.GL import *
from OpenGL.GLUT import *

rot = 0
matCol = [1, 0, 0, 0]


def display():
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glPushMatrix()
    glRotatef(30, 1, 1, 0)
    glRotatef(rot, 0, 1, 1)
    glMaterialfv(GL_FRONT, GL_DIFFUSE, matCol)
    glutWireTeapot(0.5)
    glPopMatrix()
    glFlush()


def on_idle():
    global rot
    rot += 0.01
    glutPostRedisplay()


def init():
    pos = [1, 1, 1, 0]
    white = [1, 1, 1, 0]
    shini = [70]

    glClearColor(0.5, 0.5, 0.5, 0)
    glShadeModel(GL_SMOOTH)
    glLightfv(GL_LIGHT0, GL_AMBIENT, white)
    glLightfv(GL_LIGHT0, GL_DIFFUSE, white)
    glMaterialfv(GL_FRONT, GL_SHININESS, shini)
    glEnable(GL_LIGHTING)
    glEnable(GL_LIGHT0)
    glEnable(GL_DEPTH_TEST)


def main():
    glutInit(1, 1)
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH)
    glutInitWindowSize(900, 700)
    glutCreateWindow(
        "The Amazing, Rotating Utah Teapot brought to you in OpenGL via freeglut."
    )
    init()
    glutDisplayFunc(display)
    glutIdleFunc(on_idle)
    glutMainLoop()


if __name__ == "__main__":
    main()
