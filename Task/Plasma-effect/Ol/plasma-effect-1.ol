; creating the "plasma" image buffer
(import (scheme inexact))
(define plasma
   (fold append #null
      (map (lambda (y)
            (map (lambda (x)
                  (let ((value (/
                           (+ (sin (/ y 4))
                              (sin (/ (+ x y) 8))
                              (sin (/ (sqrt (+ (* x x) (* y y))) 8))
                              4) 8)))
                     value))
               (iota 256)))
         (iota 256))))
