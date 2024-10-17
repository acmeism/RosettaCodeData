(import (scheme base)
        (scheme write)
        (srfi 1 lists)
        (only (srfi 13 strings) string-pad-right)
        (srfi 27 random-bits))

(define (analytical-function n)
  (define (factorial n)
    (fold * 1 (iota n 1)))
  ;
  (fold (lambda (i sum)
          (+ sum
             (/ (factorial n) (expt n i) (factorial (- n i)))))
        0
        (iota n 1)))

(define (simulation n runs)
  (define (single-simulation)
    (random-source-randomize! default-random-source)
    (let ((vec (make-vector n #f)))
      (let loop ((count 0)
                 (num (random-integer n)))
        (if (vector-ref vec num)
          count
          (begin (vector-set! vec num #t)
                 (loop (+ 1 count)
                       (random-integer n)))))))
  ;;
  (let loop ((total 0)
             (run runs))
    (if (zero? run)
      (/ total runs)
      (loop (+ total (single-simulation))
            (- run 1)))))

(display " N   average   formula   (error) \n")
(display "=== ========= ========= =========\n")
(for-each
  (lambda (n)
    (let ((simulation (inexact (simulation n 10000)))
          (formula (inexact (analytical-function n))))
      (display
        (string-append
          " "
          (string-pad-right (number->string n) 3)
          "   "
          (string-pad-right (number->string simulation) 6)
          "   "
          (string-pad-right (number->string formula) 6)
          "   ("
          (string-pad-right
            (number->string (* 100 (/ (- simulation formula) formula)))
            5)
          "%)"))
      (newline)))
  (iota 20 1))
