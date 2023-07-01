#lang racket

(define (in-unit-circle? x y) (<= (sqrt (+ (sqr x) (sqr y))) 1))
;; point in ([-1,1], [-1,1])
(define (random-point-in-2x2-square) (values (* 2 (- (random) 1/2)) (* 2 (- (random) 1/2))))

;; Area of circle is (pi r^2). r is 1, area of circle is pi
;; Area of square is 2^2 = 4
;; There is a pi/4 chance of landing in circle
;; .: pi = 4*(proportion passed) = 4*(passed/samples)
(define (passed:samples->pi passed samples) (* 4 (/ passed samples)))

;; generic kind of monte-carlo simulation
(define (monte-carlo run-length report-frequency
                     sample-generator pass?
                     interpret-result)
  (let inner ((samples 0) (passed 0) (cnt report-frequency))
    (cond
      [(= samples run-length) (interpret-result passed samples)]
      [(zero? cnt) ; intermediate report
       (printf "~a samples of ~a: ~a passed -> ~a~%"
               samples run-length passed (interpret-result passed samples))
       (inner samples passed report-frequency)]
      [else
       (inner (add1 samples)
              (if (call-with-values sample-generator pass?)
                  (add1 passed) passed) (sub1 cnt))])))

;; (monte-carlo ...) gives an "exact" result... which will be a fraction.
;; to see how it looks as a decimal we can exact->inexact it
(let ((mc (monte-carlo 10000000 1000000 random-point-in-2x2-square in-unit-circle? passed:samples->pi)))
  (printf "exact = ~a~%inexact = ~a~%(pi - guess) = ~a~%" mc (exact->inexact mc) (- pi mc)))
