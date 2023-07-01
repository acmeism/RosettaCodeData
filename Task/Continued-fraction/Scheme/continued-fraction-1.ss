#!r6rs
(import (rnrs base (6))
        (srfi :41 streams))

(define nats (stream-cons 0 (stream-map (lambda (x) (+ x 1)) nats)))

(define (build-stream fn) (stream-map fn nats))

(define (stream-cycle s . S)
  (cond
    ((stream-null? (car S)) stream-null)
    (else (stream-cons (stream-car s)
                       (apply stream-cycle (append S (list (stream-cdr s))))))))

(define (cf-floor cf) (stream-car cf))
(define (cf-num cf) (stream-car (stream-cdr cf)))
(define (cf-denom cf) (stream-cdr (stream-cdr cf)))

(define (cf-integer? x) (stream-null? (stream-cdr x)))

(define (cf->real x)
  (let refine ((x x) (n 65536))
    (cond
      ((= n 0) +inf.0)
      ((cf-integer? x) (cf-floor x))
      (else (+ (cf-floor x)
               (/ (cf-num x)
                  (refine (cf-denom x) (- n 1))))))))

(define (real->cf x)
  (let-values (((integer-part fractional-part) (div-and-mod x 1)))
    (if (= fractional-part 0.0)
        (stream (exact integer-part))
        (stream-cons
         (exact integer-part)
         (stream-cons
          1
          (real->cf (/ fractional-part)))))))


(define sqrt2 (stream-cons 1 (stream-constant 1 2)))

(define napier
  (stream-append (stream 2 1)
                 (stream-cycle (stream-cdr nats) (stream-cdr nats))))

(define pi
  (stream-cons 3
               (stream-cycle (build-stream (lambda (n) (expt (- (* 2 (+ n 1)) 1) 2)))
                             (stream-constant 6))))
