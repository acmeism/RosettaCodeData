#lang racket
(require math/statistics math/special-functions)

(define (p-value S1 S2 #:n (n 11000))
  (define σ²1 (variance S1 #:bias #t))
  (define σ²2 (variance S2 #:bias #t))
  (define N1 (sequence-length S1))
  (define N2 (sequence-length S2))
  (define σ²/sz1 (/ σ²1 N1))
  (define σ²/sz2 (/ σ²2 N2))

  (define degrees-of-freedom
    (/ (sqr (+ σ²/sz1 σ²/sz2))
       (+ (/ (sqr σ²1) (* (sqr N1) (sub1 N1)))
          (/ (sqr σ²2) (* (sqr N2) (sub1 N2))))))

  (define a (/ degrees-of-freedom 2))
  (define a-1 (sub1 a))
  (define x (let ((welch-t-statistic (/ (- (mean S1) (mean S2)) (sqrt (+ σ²/sz1 σ²/sz2)))))
              (/ degrees-of-freedom (+ (sqr welch-t-statistic) degrees-of-freedom))))
  (define h (/ x n))

  (/ (* (/ h 6)
        (+ (* (expt x a-1)
              (expt (- 1 x) -1/2))
           (* 4 (for/sum ((i (in-range 0 n)))
                  (* (expt (+ (* h i) (/ h 2)) a-1)
                     (expt (- 1 (+ (* h i) (/ h 2))) -1/2))))
           (* 2  (for/sum ((i (in-range 0 n)))
                   (* (expt (* h i) a-1) (expt (- 1 (* h i)) -1/2))))))
     (* (gamma a) 1.77245385090551610 (/ (gamma (+ a 1/2))))))

(module+ test
  (list
   (p-value (list 27.5 21.0 19.0 23.6 17.0 17.9 16.9 20.1 21.9 22.6 23.1 19.6 19.0 21.7 21.4)
            (list 27.1 22.0 20.8 23.4 23.4 23.5 25.8 22.0 24.8 20.2 21.9 22.1 22.9 20.5 24.4))

   (p-value (list 17.2 20.9 22.6 18.1 21.7 21.4 23.5 24.2 14.7 21.8)
            (list 21.5 22.8 21.0 23.0 21.6 23.6 22.5 20.7 23.4 21.8
                  20.7 21.7 21.5 22.5 23.6 21.5 22.5 23.5 21.5 21.8))

   (p-value (list 19.8 20.4 19.6 17.8 18.5 18.9 18.3 18.9 19.5 22.0)
            (list 28.2 26.6 20.1 23.3 25.2 22.1 17.7 27.6 20.6 13.7
                  23.2 17.5 20.6 18.0 23.9 21.6 24.3 20.4 24.0 13.2))

   (p-value (list 30.02 29.99 30.11 29.97 30.01 29.99)
            (list 29.89 29.93 29.72 29.98 30.02 29.98))

   (p-value (list 3.0 4.0 1.0 2.1)
            (list 490.2 340.0 433.9))))
