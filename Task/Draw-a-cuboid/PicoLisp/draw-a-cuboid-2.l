(load "@lib/openGl.l")

(setq *AngleX -26.0 *AngleY 74.0)
(setq *LastX 0 *LastY 0)

(glutInit)
(glutInitDisplayMode (| GLUT_RGBA GLUT_DOUBLE GLUT_DEPTH))
(glutInitWindowSize 512 512)
(glutInitWindowPosition 10 50)
(glutCreateWindow "PicoLisp Cube")

(glClearColor 1.0 1.0 1.0 1.0)	# The background color
(glEnable GL_DEPTH_TEST)
(glEnable GL_LIGHTING)
(glEnable GL_LIGHT0)
(glDisable GL_CULL_FACE)

(glEnable GL_BLEND)
(glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)
(glEnable GL_LINE_SMOOTH)
(glHint GL_LINE_SMOOTH_HINT GL_NICEST)
(glLineWidth 2.0)

(mouseFunc
   '((Btn State X Y)
      (setq *LastX X  *LastY Y) ) )

(motionFunc
   '((X Y)
      (inc '*AngleX (* (- Y *LastY) 1.0))
      (inc '*AngleY (* (- X *LastX) 1.0))
      (setq *LastX X  *LastY Y)
      (glutPostRedisplay) ) )

(reshapeFunc
   '((Width Height)
      (glMatrixMode GL_PROJECTION)
      (glLoadIdentity)
      (gluPerspective 45.0 (*/ Width 1.0 Height) 1.0 10.0)
      (glMatrixMode GL_MODELVIEW)
      (glViewport 0 0 Width Height) ) )

(displayPrg
	(glClear (| GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
	(glLoadIdentity)
	(glTranslatef 0.0 0.0 -3.0)
	(glRotatef *AngleX 1 0 0)
	(glRotatef *AngleY 0 1 0)
	(glutSolidCube 1.0)
	
	(glDisable GL_LIGHTING)
	(glColor4f 0.4 0.4 0.4 1.0)
	(glutWireCube 1.002)
	(glEnable GL_LIGHTING)
	
	(glFlush)
	(glutSwapBuffers) )

(glutMainLoop)
