; maze generation
(import (otus random!))
(define WIDTH 30)
(define HEIGHT 8)

(define maze
   (map (lambda (?)
         (repeat #b01111 WIDTH)) ; 0 - unvisited, 1111 - all walls exists
      (iota HEIGHT)))
(define (at x y)
   (list-ref (list-ref maze y) x))

(define (unvisited? x y)
   (if (and (< -1 x WIDTH) (< -1 y HEIGHT))
      (zero? (band (at x y) #b10000))))
(define neighbors '((-1 . 0) (0 . -1) (+1 . 0) (0 . +1)))
(define walls     '( #b10111  #b11011  #b11101  #b11110))
(define antiwalls '( #b11101  #b11110  #b10111  #b11011))

(let loop ((x (rand! WIDTH)) (y (rand! HEIGHT)))
   (list-set! (list-ref maze y) x (bor (at x y) #b10000))
   (let try ()
      (if (or
            (unvisited? (- x 1) y) ; left
            (unvisited? x (- y 1)) ; top
            (unvisited? (+ x 1) y) ; right
            (unvisited? x (+ y 1))) ; bottom
         (let*((p (rand! 4))
               (neighbor (list-ref neighbors p)))
            (let ((nx (+ x (car neighbor)))
                  (ny (+ y (cdr neighbor))))
            (if (unvisited? nx ny)
               (let ((ncell (at nx ny)))
                  (list-set! (list-ref maze y) x (band (at x y) (list-ref walls p)))
                  (list-set! (list-ref maze ny) nx (band ncell (list-ref antiwalls p)))
                  (loop nx ny)))
            (try))))))
