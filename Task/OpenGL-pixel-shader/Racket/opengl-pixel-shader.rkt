#lang racket/gui
(require typed/opengl)

(define (resize w h)
  (glViewport 0 0 w h))

;; shaders gotten from [#C]
(define shader-source:fragment
  #<<<
varying float x, y, z;
uniform float r_mod;
float rand(float s, float r) { return mod(mod(s, r + r_mod) * 112341, 1); }
void main() {
  gl_FragColor = vec4(rand(gl_FragCoord.x, x),
                      rand(gl_FragCoord.y, y),
                      rand(gl_FragCoord.z, z),
                      1);
}
<
  )

(define shader-source:vertex
  #<<<
varying float x, y, z;
void main() {
  gl_Position = ftransform();
  x = gl_Position.x;
  y = gl_Position.y;
  z = gl_Position.z;
  x += y;
  y -= x;
  z += x - y;
}
<
  )

(define (draw-opengl prg)
  (glClearColor 0.0 0.0 0.0 0.0)
  (glClear GL_COLOR_BUFFER_BIT)
  (glShadeModel GL_SMOOTH)
  (glMatrixMode GL_PROJECTION)
  (glLoadIdentity)
  (glOrtho 0.0 1.0 0.0 1.0 -1.0 1.0)
  (glMatrixMode GL_MODELVIEW)
  (glLoadIdentity)
  (glBegin GL_TRIANGLES)
  (glVertex3d 0.25 0.25 0.0)
  (glVertex3d 0.75 0.25 0.0)
  (glVertex3d 0.75 0.75 0.0)
  (glEnd))


(define my-canvas%
  (class* canvas% ()
    (inherit with-gl-context swap-gl-buffers)
    (define the-program #f)

    (define/override (on-paint)
      (with-gl-context
          (λ()
            (unless the-program
              (set! the-program
                    (create-program (load-shader (open-input-string shader-source:fragment)
                                                 GL_FRAGMENT_SHADER)
                                    (load-shader (open-input-string shader-source:vertex)
                                                 GL_VERTEX_SHADER)))
              (glUseProgram the-program))
            (draw-opengl the-program) (swap-gl-buffers))))
    (define/override (on-size width height)
      (with-gl-context (λ() (resize width height))))
    (super-instantiate () (style '(gl)))))

(define win (new frame% [label "Racket Rosetta Code OpenGL example"]
                        [min-width 200] [min-height 200]))
(define gl  (new my-canvas% [parent win]))

(send win show #t)
