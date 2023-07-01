(load "@lib/openGl.l")

(setq *JoyX 0.0  *JoyY 0.0)

(glutInit)
(glutInitDisplayMode (| GLUT_RGBA GLUT_DOUBLE GLUT_ALPHA GLUT_DEPTH))
(glutInitWindowSize 400 400)
(glutCreateWindow "Joystick")

(glClearColor 0.3 0.3 0.5 0)

(displayPrg
   (glClear GL_COLOR_BUFFER_BIT)
   (glBegin GL_LINES)
   (glVertex2f *JoyX (- *JoyY 0.1))  # Draw crosshair
   (glVertex2f *JoyX (+ *JoyY 0.1))
   (glVertex2f (- *JoyX 0.1) *JoyY)
   (glVertex2f (+ *JoyX 0.1) *JoyY)
   (glEnd)
   (glFlush)
   (glutSwapBuffers) )

# Track joystick position
(native `*GlutLib "glutJoystickFunc" NIL
   (lisp 'joystickFunc
      '((Btn X Y Z)
         (msg                          # Display buttons
            (make
               (for (B 1 (n0 Btn) (inc B))
                  (and (bit? 1 Btn) (link B))
                  (setq Btn (>> 1 Btn)) ) ) )
         (setq                         # Move crosshair
            *JoyX (*/ X 1.0 1000)
            *JoyY (*/ Y 1.0 1000) )
         (glutPostRedisplay) ) )
   100 )

# Exit upon mouse click
(mouseFunc '((Btn State X Y) (bye)))
(glutMainLoop)
