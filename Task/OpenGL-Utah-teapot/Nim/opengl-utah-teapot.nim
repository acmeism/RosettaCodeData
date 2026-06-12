import opengl, opengl/glut

var
  rot = 0.0
  matCol = [GLfloat 1, 0, 0, 0]

proc onIdle() {.cdecl.} =
  rot += 0.01
  glutPostRedisplay()

proc display() {.cdecl.} =
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glPushMatrix()
  glRotatef(30, 1, 1, 0)
  glRotatef(rot, 0, 1, 1)
  glMaterialfv(GL_FRONT, GL_DIFFUSE, addr(matCol[0]))
  glutWireTeapot(0.5)
  glPopMatrix()
  glFlush()

var argc: cint = 0
glutInit(addr(argc), nil)
glutInitDisplayMode(GLUT_SINGLE or GLUT_RGB or GLUT_DEPTH)
glutInitWindowSize(900, 700)
discard glutCreateWindow("Utah Teapot")
glutIdleFunc(onIdle)
glutDisplayFunc(display)
loadExtensions()
glutMainLoop()
