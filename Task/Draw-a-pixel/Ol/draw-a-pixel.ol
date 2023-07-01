(import (lib gl))
(import (OpenGL version-1-0))

; init
(glClearColor 0.3 0.3 0.3 1)
(glOrtho 0 320 0 240 0 1)

; draw loop
(gl:set-renderer (lambda (mouse)
   (glClear GL_COLOR_BUFFER_BIT)
   (glBegin GL_POINTS)
   (glColor3f 255 0 0)
   (glVertex2f 100 100)
   (glEnd)))
