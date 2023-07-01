; rendering the prepared buffer (using OpenGL)
(import (lib gl1))
(gl:set-window-size 256 256)

(glBindTexture GL_TEXTURE_2D 0)
(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_LINEAR)
(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_LINEAR)
(glTexImage2D GL_TEXTURE_2D 0 GL_LUMINANCE
   256 256
   0 GL_LUMINANCE GL_FLOAT (cons (fft* fft-float) plasma))

(glEnable GL_TEXTURE_2D)

(gl:set-renderer (lambda (_)
   (glClear GL_COLOR_BUFFER_BIT)
   (glBegin GL_QUADS)
      (glTexCoord2f 0 0)
      (glVertex2f -1 -1)
      (glTexCoord2f 0 1)
      (glVertex2f -1 1)
      (glTexCoord2f 1 1)
      (glVertex2f 1 1)
      (glTexCoord2f 1 0)
      (glVertex2f 1 -1)
   (glEnd)))
