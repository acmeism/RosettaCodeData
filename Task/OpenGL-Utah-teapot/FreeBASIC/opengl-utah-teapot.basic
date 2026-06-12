#Include Once "GL/glut.bi"

Dim Shared As Double rot = 0.0

Sub onIdle Cdecl ()
    rot += 0.01
    glutPostRedisplay()
End Sub

Sub display Cdecl ()
    Dim matCol(0 To 3) As Const GLfloat = {1, 0, 0, 0}
    glClear GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT
    glPushMatrix()
    glRotatef(30, 1, 1, 0)
    glRotatef(rot, 0, 1, 1)
    glMaterialfv GL_FRONT, GL_DIFFUSE, @matCol(0)
    glutWireTeapot(0.5)
    glPopMatrix()
    glFlush()
End Sub

Sub init Cdecl ()
    Dim white(0 To 3) As Const GLfloat = {1, 1, 1, 0}
    Dim shini(1) As Const GLfloat = {70}
    glClearColor(0.5, 0.5, 0.5, 0)
    glShadeModel(GL_SMOOTH)
    glLightfv(GL_LIGHT0, GL_AMBIENT, @white(0))
    glLightfv(GL_LIGHT0, GL_DIFFUSE, @white(0))
    glMaterialfv(GL_FRONT, GL_SHININESS, @shini(0))
    glEnable(GL_LIGHTING)
    glEnable(GL_LIGHT0)
    glEnable(GL_DEPTH_TEST)
End Sub

Var argc = Cint(0)
glutInit(0, Strptr( " " ))
glutInitDisplayMode GLUT_SINGLE Or GLUT_RGB Or GLUT_DEPTH
glutInitWindowSize(900, 700)
glutCreateWindow("Utah Teapot")
glutIdleFunc(@onIdle)
glutDisplayFunc(@display)
init()
glutMainLoop()
