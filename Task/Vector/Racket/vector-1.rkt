#lang racket

(require racket/flonum)

(define (rad->deg x) (fl* 180. (fl/ (exact->inexact x) pi)))

;Custom printer
;no shared internal structures
(define (vec-print v port mode)
  (write-string "Vec:\n" port)
  (write-string (format " -Slope: ~a\n" (vec-slope v)) port)
  (write-string (format " -Angle(deg): ~a\n" (rad->deg (vec-angle v))) port)
  (write-string (format " -Norm: ~a\n" (vec-norm v)) port)
  (write-string (format " -X: ~a\n" (vec-x v)) port)
  (write-string (format " -Y: ~a\n" (vec-y v)) port))

(struct vec (x y)
        #:methods gen:custom-write
        [(define write-proc vec-print)])

;Alternative constructor
(define (vec/slope-norm s n)
  (vec (* n (/ 1 (sqrt (+ 1 (sqr s)))))
       (* n (/ s (sqrt (+ 1 (sqr s)))))))

;Properties
(define (vec-norm v)
  (sqrt (+ (sqr (vec-x v)) (sqr (vec-y v)))))

(define (vec-slope v)
  (fl/ (exact->inexact (vec-y v)) (exact->inexact (vec-x v))))

(define (vec-angle v)
  (atan (vec-y v) (vec-x v)))

;Operations
(define (vec+ v w)
  (vec (+ (vec-x v) (vec-x w))
       (+ (vec-y v) (vec-y w))))

(define (vec- v w)
  (vec (- (vec-x v) (vec-x w))
       (- (vec-y v) (vec-y w))))

(define (vec*e v l)
  (vec (* (vec-x v) l)
       (* (vec-y v) l)))

(define (vec/e v l)
  (vec (/ (vec-x v) l)
       (/ (vec-y v) l)))
