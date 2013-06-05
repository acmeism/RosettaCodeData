#lang racket
(require 2htdp/image)
(define (sierpinski n)
  (if (zero? n)
    (triangle 2 'solid 'red)
    (let ([t (sierpinski (- n 1))])
      (freeze (above t (beside t t))))))
;; the following will show the graphics if run in DrRacket
(sierpinski 8)
;; or use this to dump the image into a file, shown on the right
(require file/convertible)
(display-to-file (convert (sierpinski 8) 'png-bytes) "sierpinski.png")
