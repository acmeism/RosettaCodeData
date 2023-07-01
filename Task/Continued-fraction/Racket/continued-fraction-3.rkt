#lang racket
(require math)
(bf-precision 2048) ; in bits

(define (calc cf n)
  (match/values (cf 0)
    [(a0 b0)
     (bf+ (bf a0)
        (for/fold ([t (bf 0)]) ([i (in-range (+ n 1) 0 -1)])
          (match/values (cf i)
                        [(a b) (bf/ (bf b) (bf+ (bf a) t))])))]))

(define (cf-sqrt i)   (values  (if (> i 0) 2 1)  1))
(define (cf-napier i) (values  (if (> i 0) i 2)  (if (> i 1) (- i 1) 1)))
(define (cf-pi i)     (values  (if (> i 0) 6 3)  (sqr (- (* 2 i) 1))))

(calc cf-sqrt   200)
(calc cf-napier 200)
(calc cf-pi     200)
