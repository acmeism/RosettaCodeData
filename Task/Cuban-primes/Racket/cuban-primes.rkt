#lang racket

(require math/number-theory
         racket/generator)

(define (make-cuban-prime-generator)
  (generator ()
             (let loop ((y 1) (y3 1))
               (let* ((x (+ y 1))
                      (x3 (expt x 3))
                      (p (quotient (- x3 y3) (- x y))))
                 (when (prime? p) (yield p))
                 (loop x x3)))))

(define (tabulate l (line-width 80))
  (let* ((w (add1 (string-length (argmax string-length (map ~a l)))))
         (cols (quotient line-width w)))
    (for ((n (in-range 1 (add1 (length l))))
          (i l))
      (display (~a i #:width w #:align 'right))
      (when (zero? (modulo n cols)) (newline)))))

(define (progress-report x)
  (when (zero? (modulo x 1000))
    (eprintf (if (zero? (modulo x 10000)) "|" "."))
    (flush-output (current-error-port))))

(let ((200-cuban-primes (for/list ((_ 200)
                                   (p (in-producer (make-cuban-prime-generator))))
                          p)))
  (tabulate 200-cuban-primes))

(begin0
  (for/last ((x 100000)
             (p (in-producer (make-cuban-prime-generator))))
    (progress-report x)
    p)
  (newline))
