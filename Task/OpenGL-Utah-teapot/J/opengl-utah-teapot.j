NB. Teapot using freeglut
require '~Projects/freeglut/gldefs.ijs'

f=: 1.1-1.1
void=: 0$''

rot=: f+0
matCol=: f+1 0 0 0

cb1=: cdcb '+ x x'
cb2=: cdcb '+ x x x'

cdcallback=: 3 : 0
y=. 15!:17''
select. #y
  case. 1 do. display 0
  case. 2 do. onIdle 0
end.
)

display=: 3 : 0
glClear(GL_COLOR_BUFFER_BIT+GL_DEPTH_BUFFER_BIT)
glPushMatrix void
glRotatef((30+f);(1+f);(1+f);f)
glRotatef(rot;f;(1+f);(1+f))
glMaterialfv(GL_FRONT;GL_DIFFUSE;<matCol)
glutWireTeapot(0.5)
glPopMatrix void
glFlush void
)

onIdle=: 3 : 0
rot=: rot+0.01
glutPostRedisplay void
)

init=: 3 : 0
pos=. f+1,1,1,0
white=. f+1,1,1,0
shini=. ,f+70

glClearColor(0.5;0.5;0.5;f)
glShadeModel(GL_SMOOTH)
glLightfv(GL_LIGHT0;GL_AMBIENT;white)
glLightfv(GL_LIGHT0;GL_DIFFUSE;white)
glMaterialfv(GL_FRONT;GL_SHININESS;shini)
glEnable(GL_LIGHTING)
glEnable(GL_LIGHT0)
glEnable(GL_DEPTH_TEST)
)

main=: 3 : 0
argC=. ,2-2
argV=.<,0{a.

glutInit(argC;argV)
glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE;GLUT_ACTION_GLUTMAINLOOP_RETURNS)
glutInitDisplayMode(GLUT_SINGLE+GLUT_RGB+GLUT_DEPTH)
glutInitWindowSize(900;700)
glutCreateWindow(<'The Amazing, Rotating Utah Teapot brought to you in OpenGL via freeglut.')
init void
glutDisplayFunc(cb1)
glutIdleFunc(cb2)
glutMainLoop void
void
)
