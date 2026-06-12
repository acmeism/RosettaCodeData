package main

/*
#cgo LDFLAGS: -lGL -lGLU -lglut
#include <stdlib.h>
#include <GL/freeglut.h>

extern void display();
extern void onIdle();

typedef void (*callback) ();

static inline callback displayFunc() {
    return display;
}

static inline callback idleFunc() {
    return onIdle;
}
*/
import "C"
import "unsafe"

var rot = 0.0
var matCol = [4]C.float{1, 0, 0, 0}

//export display
func display() {
    C.glClear(C.GL_COLOR_BUFFER_BIT | C.GL_DEPTH_BUFFER_BIT)
    C.glPushMatrix()
    C.glRotatef(30, 1, 1, 0)
    C.glRotatef(C.float(rot), 0, 1, 1)
    C.glMaterialfv(C.GL_FRONT, C.GL_DIFFUSE, &matCol[0])
    C.glutWireTeapot(0.5)
    C.glPopMatrix()
    C.glFlush()
}

//export onIdle
func onIdle() {
    rot += 0.01
    C.glutPostRedisplay()
}

func initialize() {
    white := [4]C.float{1, 1, 1, 0}
    shini := [1]C.float{70}
    C.glClearColor(0.5, 0.5, 0.5, 0)
    C.glShadeModel(C.GL_SMOOTH)
    C.glLightfv(C.GL_LIGHT0, C.GL_AMBIENT, &white[0])
    C.glLightfv(C.GL_LIGHT0, C.GL_DIFFUSE, &white[0])
    C.glMaterialfv(C.GL_FRONT, C.GL_SHININESS, &shini[0])
    C.glEnable(C.GL_LIGHTING)
    C.glEnable(C.GL_LIGHT0)
    C.glEnable(C.GL_DEPTH_TEST)
}

func main() {
    argc := C.int(0)
    C.glutInit(&argc, nil)
    C.glutInitDisplayMode(C.GLUT_SINGLE | C.GLUT_RGB | C.GLUT_DEPTH)
    C.glutInitWindowSize(900, 700)
    tl := "The Amazing, Rotating Utah Teapot brought to you in OpenGL via freeglut."
    tlc := C.CString(tl)
    C.glutCreateWindow(tlc)
    initialize()
    C.glutDisplayFunc(C.displayFunc())
    C.glutIdleFunc(C.idleFunc())
    C.glutMainLoop()
    C.free(unsafe.Pointer(tlc))
}
