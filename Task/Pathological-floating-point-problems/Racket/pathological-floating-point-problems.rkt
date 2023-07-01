#lang racket

(define current-do-exact-calculations? (make-parameter exact->inexact))

(define (x n) (if (current-do-exact-calculations?) n (exact->inexact n)))

(define (decimal.18 n)
  (regexp-replace #px"0+$" (real->decimal-string n 18) ""))

(define (task-1 n)
  (let ((c_1 (x 111)) (c_2 (x -1130)) (c_3 (x 3000)))
    (let loop ((v_n-2 (x 2)) (v_n-1 (x -4)) (n (- n 2)))
      (if (= n 0) v_n-1 (loop v_n-1 (+ c_1 (/ c_2 v_n-1) (/ c_3 (* v_n-1 v_n-2))) (- n 1))))))

(define (task-2) ; chaotic bank
   (define e (if (current-do-exact-calculations?)
                 #e2.71828182845904523536028747135266249775724709369995
                 (exp 1)))
  (for/fold ((b (- e 1))) ((y (in-range 1 26))) (- (* b y) 1)))

(define (task-3 a b)
    (+ (* (x #e333.75) (expt b 6))
       (* (expt a 2) (- (* 11 (expt a 2) (expt b 2)) (expt b 6) (* 121 (expt b 4)) 2))
       (* (x #e5.5) (expt b 8))
       (/ a (* b 2))))

(define (all-tests)
  (let ((classic-sum (+ (x #e0.2) (x #e0.1))))
    (printf "Classic example: ~a = ~a~%" classic-sum (decimal.18 classic-sum)))

  (displayln "TASK 1")
  (for ((n (in-list '(3 4 5 6 7 8 20 30 50 100))))
    (printf "n=~a\t~a~%" n (decimal.18 (task-1 n))))

  (printf "TASK 2: balance after 25 years = ~a~%" (decimal.18 (task-2)))

  (let ((t3 (task-3 77617 33096)))
    (printf "TASK 3: f(77617, 33096) = ~a = ~a~%" t3 (decimal.18 t3))))

(module+ main
  (displayln "INEXACT (Floating Point) NUMBERS")
  (parameterize ([current-do-exact-calculations? #f])
    (all-tests))
  (newline)

  (displayln "EXACT (Rational) NUMBERS")
  (parameterize ([current-do-exact-calculations? #t])
    (all-tests)))
