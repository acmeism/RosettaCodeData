#!/usr/bin/ol
(import (otus random!))

(define MAX 65536)  ; should be power of two
; size of game board (should be less than MAX)
(define WIDTH 170)
(define HEIGHT 96)

; helper function
(define (hash x y)
   (let ((x (mod (+ x WIDTH) WIDTH))
         (y (mod (+ y HEIGHT) HEIGHT)))
   (+ (* y MAX) x)))

; helper function
(define neighbors '(
   (-1 . -1) ( 0 . -1) ( 1 . -1)
   (-1 .  0)           ( 1 .  0)
   (-1 .  1) ( 0 .  1) ( 1 .  1)
))

; dead-or-alive cell test
(define (alive gen x y)
   (case (fold (lambda (f xy)
                     (+ f (get gen (hash (+ x (car xy)) (+ y (cdr xy))) 0)))
               0 neighbors)
      (2
         (get gen (hash x y) #false))
      (3
         #true)))

; ---------------
(import (lib gl2))
(gl:set-window-title "Convey's The game of Life")

(glShadeModel GL_SMOOTH)
(glClearColor 0.11 0.11 0.11 1)
(glOrtho 0 WIDTH 0 HEIGHT 0 1)

(glPointSize (/ 854 WIDTH))

; generate random field
(gl:set-userdata
   (list->ff (map (lambda (i) (let ((x (rand! WIDTH)) (y (rand! HEIGHT)))
                                 (cons (hash x y) 1))) (iota 2000))))
; main game loop
(gl:set-renderer (lambda (mouse)
(let ((generation (gl:get-userdata)))
   (glClear GL_COLOR_BUFFER_BIT)

   ; draw the cells
   (glColor3f 0.2 0.5 0.2)
   (glBegin GL_POINTS)
      (ff-fold (lambda (st key value)
         (glVertex2f (mod key MAX)
                     (div key MAX))
      ) #f generation)
   (glEnd)

   (gl:set-userdata
      ; next cells generation
      (ff-fold (lambda (st key value)
         (let ((x (mod key MAX))
               (y (div key MAX)))
            (fold (lambda (st key)
                     (let ((x (+ x (car key)))
                           (y (+ y (cdr key))))
                        (if (alive generation x y) (put st (hash x y) 1) st)))
               (if (alive generation x y) (put st (hash x y) 1) st) ; the cell
               neighbors)))
         #empty generation)))))
