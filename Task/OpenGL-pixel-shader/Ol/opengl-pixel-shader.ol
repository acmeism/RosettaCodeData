#!/usr/bin/ol
(import (lib gl2))

; init
(glShadeModel GL_SMOOTH)
(glClearColor 0.11 0.11 0.11 1)

(define po (gl:CreateProgram
"#version 120 // OpenGL 2.1
	varying float x, y, z;
	void main(void) {
		gl_Position = ftransform();
		x = gl_Position.x; y = gl_Position.y; z = gl_Position.z;
		x += y; y -= x; z += x - y;
	}"
"#version 120 // OpenGL 2.1
	varying float x, y, z;
	uniform float r_mod;
	float rand(float s, float r) { return mod(mod(s, r + r_mod) * 112341, 1); }
	
	void main() {
		gl_FragColor = vec4(rand(gl_FragCoord.x, x), rand(gl_FragCoord.y, y), rand(gl_FragCoord.z, z), 1);
	}"))

; draw
(gl:set-renderer (lambda (mouse)
   (glClear GL_COLOR_BUFFER_BIT)

   (glUseProgram po)
   (glUniform1f (glGetUniformLocation po (c-string "r_mod")) 1)

   (glColor3f 1 1 1)
   (glBegin GL_TRIANGLES)
      (glVertex2f -0.6 -0.6)
      (glVertex2f +0.6 -0.6)
      (glVertex2f -0.0 +0.7)
   (glEnd)))
