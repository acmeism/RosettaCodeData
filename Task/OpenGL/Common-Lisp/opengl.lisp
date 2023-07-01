(defun draw-triangle (x y &key (z 0) (type 'right))
  (case type
    (right
     (gl:with-primitive :triangles
       (gl:color 0 0 1)
       (gl:vertex x y z)
       (gl:color 0 1 0)
       (gl:vertex x (- y 1) z)
       (gl:color 1 0 0)
       (gl:vertex (+ x 1) (1- y) z)))
    (equilateral
     (gl:with-primitive :triangles
       (gl:color 0 0 1)
       (gl:vertex (+ x 0.5) y z)
       (gl:color 1 0 0)
       (gl:vertex (- x 0.5) (- y 1) z)
       (gl:color 0 1 0)
       (gl:vertex (+ x 1.5) (- y 1) z)))))

(defun draw-update ()
  (gl:clear :color-buffer :depth-buffer :color-buffer-bit)
  (gl:matrix-mode :modelview)
  (gl:load-identity)

  (gl:color 1.0 1.0 1.0)
  (gl:translate 0 0 -2)

  (draw-triangle -0.5 0.5 :type 'equilateral))

(defun main-loop ()
  (sdl:with-events ()
    (:quit-event () t)
    (:key-down-event (:key key)
                     (cond ((sdl:key= key :sdl-key-escape)
                            (sdl:push-quit-event))))
    (:idle ()
           (draw-update)
           (sdl:update-display))))

(defun setup-gl (w h)
  (gl:clear-color 0.5 0.5 0.5 1)
  (gl:clear-depth 1)

  (gl:viewport 0 0 w h)

  (gl:depth-func :lequal)
  (gl:hint :perspective-correction-hint :nicest)
  (gl:shade-model :smooth)
  (gl:enable :depth-test :cull-face)

  (gl:matrix-mode :projection)
  (gl:load-identity)
  (glu:perspective 45 (/ w (max h 1)) 0.1 20)

  (gl:matrix-mode :modelview)
  (gl:load-identity))

(defun triangle (&optional (w 640) (h 480))
  (sdl:with-init ()
    (sdl:set-gl-attribute :SDL-GL-DEPTH-SIZE 16)
    (sdl:window w h
                :bpp 32
                :flags sdl:sdl-opengl
                :title-caption "Rosettacode.org OpenGL Demo")
    (setup-gl w h)
    (setf (sdl:frame-rate) 2)
    (main-loop)))
