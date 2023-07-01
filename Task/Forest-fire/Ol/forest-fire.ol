(import (lib gl))
(import (otus random!))

(define WIDTH 170)
(define HEIGHT 96)

; probabilities
(define p 20)
(define f 1000)

(gl:set-window-title "Drossel and Schwabl 'forest-fire'")
(import (OpenGL version-1-0))

   (glShadeModel GL_SMOOTH)
   (glClearColor 0.11 0.11 0.11 1)
   (glOrtho 0 WIDTH 0 HEIGHT 0 1)

(gl:set-userdata (make-vector (map (lambda (-) (make-vector (map (lambda (-) (rand! 2)) (iota WIDTH)))) (iota HEIGHT))))

(gl:set-renderer (lambda (mouse)
   (let ((forest (gl:get-userdata))
         (step (make-vector (map (lambda (-) (make-vector (repeat 0 WIDTH))) (iota HEIGHT)))))
      (glClear GL_COLOR_BUFFER_BIT)

      (glPointSize (/ 854 WIDTH))
      (glBegin GL_POINTS)
         (for-each (lambda (y)
               (for-each (lambda (x)
                     (case (ref (ref forest y) x)
                        (0 ; An empty space fills with a tree with probability "p"
                           (if (zero? (rand! p))
                              (set-ref! (ref step y) x 1)))
                        (1
                           (glColor3f 0.2 0.7 0.2)
                           (glVertex2f x y)
                           ; A tree will burn if at least one neighbor is burning
                           ; A tree ignites with probability "f" even if no neighbor is burning
                           (if (or (eq? (ref (ref forest (- y 1)) (- x 1)) 2)  (eq? (ref (ref forest (- y 1))    x)    2)  (eq? (ref (ref forest (- y 1)) (+ x 1)) 2)
                                   (eq? (ref (ref forest    y   ) (- x 1)) 2)                                              (eq? (ref (ref forest    y   ) (+ x 1)) 2)
                                   (eq? (ref (ref forest (+ y 1)) (- x 1)) 2)  (eq? (ref (ref forest (+ y 1))    x)    2)  (eq? (ref (ref forest (+ y 1)) (+ x 1)) 2)
                                   (zero? (rand! f)))
                              (set-ref! (ref step y) x 2)
                              (set-ref! (ref step y) x 1)))
                        (2
                           (glColor3f 0.7 0.7 0.1)
                           (glVertex2f x y))
                           ; A burning cell turns into an empty cell
                           (set-ref! (ref step y) x 0)))
                  (iota WIDTH)))
            (iota HEIGHT))
      (glEnd)
      (gl:set-userdata step))))
