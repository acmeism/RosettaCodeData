(import (lib gl))
(import (OpenGL version-1-0))

; init
(glClearColor 0.3 0.3 0.3 1)
(glPolygonMode GL_FRONT_AND_BACK GL_FILL)

(define quadric (gluNewQuadric))

; draw loop
(gl:set-renderer (lambda (mouse)
   (glClear GL_COLOR_BUFFER_BIT)

   (glColor3f 0.7 0.7 0.7)
   (gluSphere quadric 0.4 32 10)
))
