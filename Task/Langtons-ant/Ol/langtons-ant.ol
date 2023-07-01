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

;; ; helper function
(define directions '(
   (0 . 1) (1 . 0) (0 . -1) (-1 . 0)
))

; ---------------
(import (lib gl2))
(gl:set-window-title "Langton's Ant")

(glShadeModel GL_SMOOTH)
(glClearColor 0.11 0.11 0.11 1)
(glOrtho 0 WIDTH 0 HEIGHT 0 1)

(glPointSize (/ 854 WIDTH))

; generate random field
(gl:set-userdata
   (list->ff (map (lambda (i) (let ((x (rand! WIDTH)) (y (rand! HEIGHT)))
                                 (cons (hash x y) #t))) (iota 1000))))

(define ant (cons
   (rand! WIDTH)
   (rand! HEIGHT)))
(define dir (list (rand! 4))) ; 0, 1, 2, 3

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
      (glColor3f 0.8 0.2 0.1)
      (glVertex2f (car ant) (cdr ant))
   (glEnd)

   (gl:set-userdata
      (let*((x (car ant))
            (y (cdr ant))
            (generation (case (get generation (hash x y) #f)
                           (#true ; black cell
                              (set-car! dir (mod (+ (car dir) 1) 4))
                              (del generation (hash x y)))
                           (#false
                              (set-car! dir (mod (+ (car dir) 7) 4))
                              (put generation (hash x y) #true)))))
         (set-car! ant (mod (+ x (car (lref directions (car dir)))) WIDTH))
         (set-cdr! ant (mod (+ y (cdr (lref directions (car dir)))) HEIGHT))
         generation))


)))
