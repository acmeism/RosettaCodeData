import opengl, opengl/glut

proc paint() {.cdecl.} =
  glClearColor(0.3,0.3,0.3,0.0)
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

  glShadeModel(GL_SMOOTH)

  glLoadIdentity()
  glTranslatef(-15.0, -15.0, 0.0)

  glBegin(GL_TRIANGLES)
  glColor3f(1.0, 0.0, 0.0)
  glVertex2f(0.0, 0.0)
  glColor3f(0.0, 1.0, 0.0)
  glVertex2f(30.0, 0.0)
  glColor3f(0.0, 0.0, 1.0)
  glVertex2f(0.0, 30.0)
  glEnd()

  glFlush()

proc reshape(width, height: cint) {.cdecl.} =
  glViewport(0, 0, width, height)
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  glOrtho(-30.0, 30.0, -30.0, 30.0, -30.0, 30.0)
  glMatrixMode(GL_MODELVIEW)

enableAutoGlErrorCheck(false)
loadExtensions()
glutInit()
glutInitWindowSize(640, 480)
discard glutCreateWindow("Triangle")

glutDisplayFunc(paint)
glutReshapeFunc(reshape)

glutMainLoop()
