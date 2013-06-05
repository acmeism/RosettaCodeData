#lang racket

;; some silly boilerplate to mimic the assembly code better
(define r0 0)
(define (cmp r1 r2) (set! r0 (sgn (- r1 r2))))
(define (je true-label false-label) (if (zero? r0) (true-label) (false-label)))
(define (goto label) (label))

(define (gcd %eax %ecx)
  (define %edx 0)
  (define (main) (goto loop))
  (define (loop) (cmp 0 %ecx)
                 (je end cont))
  (define (cont) (set!-values [%eax %edx] (quotient/remainder %eax %ecx))
                 (set! %eax %ecx)
                 (set! %ecx %edx)
                 (goto loop))
  (define (end)  (printf "result: ~s\n" %eax)
                 (return %eax))
  (main))
