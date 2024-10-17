(import (srfi 1 lists))  ;; use 'fold' from library

(define (average l)
  (/ (fold + 0 l) (length l)))

(define pi 3.14159265358979323846264338327950288419716939937510582097)

(define (radians a)
  (* pi 1/180 a))

(define (degrees a)
  (* 180 (/ 1 pi) a))

(define (mean-angle angles)
  (let* ((angles (map radians angles))
         (cosines (map cos angles))
         (sines (map sin angles)))
    (degrees (atan (average sines) (average cosines)))))

(for-each (lambda (angles)
            (display "The mean angle of ") (display angles)
            (display " is ") (display (mean-angle angles)) (newline))
          '((350 10) (90 180 270 360) (10 20 30)))
