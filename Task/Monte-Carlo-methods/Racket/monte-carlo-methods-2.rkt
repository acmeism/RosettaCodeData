#lang racket
(define (in-unit-circle? x y) (<= (sqrt (+ (sqr x) (sqr y))) 1))
;; Good idea made in another task that:
;;  The proportions of hits is the same in the unit square and 1/4 of a circle.
;; point in ([0,1], [0,1])
(define (random-point-in-unit-square) (values (random) (random)))
;; generic kind of monte-carlo simulation
;; Area of circle is (pi r^2). r is 1, area of circle is pi
;; Area of square is 2^2 = 4
;; There is a pi/4 chance of landing in circle
;; .: pi = 4*(proportion passed) = 4*(passed/samples)
(define (passed:samples->pi passed samples) (* 4 (/ passed samples)))

(define (monte-carlo/2 run-length report-frequency sample-generator pass? interpret-result)
  (interpret-result
   (for/fold ((pass 0))
     ([n (in-range run-length)]
      #:when (when (and (not (zero? n)) (zero? (modulo n report-frequency)))
               (printf "~a samples of ~a: ~a passed -> ~a~%"
                       n run-length pass (interpret-result pass n)))
      #:when (call-with-values sample-generator pass?))
     (add1 pass))
   run-length))

;; (monte-carlo ...) gives an "exact" result... which will be a fraction.
;; to see how it looks as a decimal we can exact->inexact it
(let ((mc (monte-carlo/2 10000000 1000000 random-point-in-unit-square in-unit-circle? passed:samples->pi)))
  (printf "exact = ~a~%inexact = ~a~%(pi - guess) = ~a~%" mc (exact->inexact mc) (- pi mc)))
