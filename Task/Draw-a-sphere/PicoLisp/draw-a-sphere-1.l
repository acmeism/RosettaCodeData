(load "@lib/openGl.l")

(glutInit)
(glutInitDisplayMode (| GLUT_RGBA GLUT_DOUBLE GLUT_ALPHA GLUT_DEPTH))
(glutInitWindowSize 400 400)
(glutCreateWindow "Sphere")

(glEnable GL_LIGHTING)
(glEnable GL_LIGHT0)
(glLightiv GL_LIGHT0 GL_POSITION (10 10 -10 0))

(glEnable GL_COLOR_MATERIAL)
(glColorMaterial GL_FRONT_AND_BACK GL_AMBIENT_AND_DIFFUSE)

(glClearColor 0.3 0.3 0.5 0)
(glColor4f 0.0 0.8 0.0 1.0)

(displayPrg
   (glClear (| GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
   (glutSolidSphere 0.9 40 32)
   (glFlush)
   (glutSwapBuffers) )

# Exit upon mouse click
(mouseFunc '((Btn State X Y) (bye)))
(glutMainLoop)
