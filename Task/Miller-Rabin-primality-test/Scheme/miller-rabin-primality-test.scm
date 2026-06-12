#!r6rs
(import (rnrs base (6))
        (srfi :27 random-bits))

;; Fast modular exponentiation.
(define (modexpt b e M)
  (cond
    ((zero? e) 1)
    ((even? e) (modexpt (mod (* b b) M) (div e 2) M))
    ((odd? e) (mod (* b (modexpt b (- e 1) M)) M))))

;; Return s, d such that d is odd and 2^s * d = n.
(define (split n)
  (let recur ((s 0) (d n))
    (if (odd? d)
        (values s d)
        (recur (+ s 1) (div d 2)))))

;; Test whether the number a proves that n is composite.
(define (composite-witness? n a)
  (let*-values (((s d) (split (- n 1)))
                ((x) (modexpt a d n)))
    (and (not (= x 1))
         (not (= x (- n 1)))
         (let try ((r (- s 1)))
           (set! x (modexpt x 2 n))
           (or (zero? r)
               (= x 1)
               (and (not (= x (- n 1)))
                    (try (- r 1))))))))

;; Test whether n > 2 is a Miller-Rabin pseudoprime, k trials.
(define (pseudoprime? n k)
  (or (zero? k)
      (let ((a (+ 2 (random-integer (- n 2)))))
        (and (not (composite-witness? n a))
             (pseudoprime? n (- k 1))))))

;; Test whether any integer is prime.
(define (prime? n)
  (and (> n 1)
       (or (= n 2)
           (pseudoprime? n 50))))
