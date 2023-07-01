#lang racket

(define (rem n m)
  (let* ((m (abs m)) (-m (- m)))
    (let recur ((n n))
      (cond [(< n -m) (recur (+ n m))]
            [(>= n m) (recur (- n m))]
            [else n]))))

(define 2.pi (* 2 pi))

(define (deg->deg a) (rem a 360))
(define (grad->grad a) (rem a 400))
(define (mil->mil a) (rem a 6400))
(define (rad->rad a) (rem a 2.pi))

(define (deg->grad a) (grad->grad (* (/ a 360) 400)))
(define (deg->rad a) (rad->rad (* (/ a 360) 2.pi)))
(define (deg->mil a) (mil->mil (* (/ a 360) 6400)))

(define (grad->deg a) (deg->deg (* (/ a 400) 360)))
(define (grad->rad a) (rad->rad (* (/ a 400) 2.pi)))
(define (grad->mil a) (mil->mil (* (/ a 400) 6400)))

(define (mil->deg a) (deg->deg (* (/ a 6400) 360)))
(define (mil->grad a) (grad->grad (* (/ a 6400) 400)))
(define (mil->rad a) (rad->rad (* (/ a 6400) 2.pi)))

(define (rad->deg a) (deg->deg (* (/ a 2.pi) 360)))
(define (rad->grad a) (grad->grad (* (/ a 2.pi) 400)))
(define (rad->mil a) (mil->mil (* (/ a 2.pi) 6400)))

(define (tabulate #:fmt (fmt (λ (v) (~a (exact->inexact v) #:align 'right #:width 15))) head . vs)
  (string-join (cons (~a #:width 6 head) (map fmt vs)) " | "))

(define (report-angle a)
  (string-join
   (list
    (tabulate #:fmt (λ (x) (~a x #:width 15 #:align 'center)) "UNIT" "VAL*" "DEG" "GRAD" "MIL" "RAD")
    (tabulate "Deg" a (deg->deg a) (deg->grad a) (deg->mil a) (deg->rad a))
    (tabulate "Grad" a (grad->deg a) (grad->grad a) (grad->mil a) (grad->rad a))
    (tabulate "Mil" a (mil->deg a) (mil->grad a) (mil->mil a) (mil->rad a))
    (tabulate "Rad" a (rad->deg a) (rad->grad a) (rad->mil a) (rad->rad a)))
   "\n"))

(module+ test
  (displayln
   (string-join (map report-angle '(-2 -1 0 1 2 6.2831853 16 57.2957795 359 399 6399 1000000))
                "\n\n")))
