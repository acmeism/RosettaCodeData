#lang racket

(require plot)

(define a098550
  (let ((hsh# (make-hash '((1 . 1) (2 . 2) (3 . 3))))
        (rev# (make-hash '((1 . 1) (2 . 2) (3 . 3)))))
    (λ (n)
      (hash-ref hsh# n
                (λ ()
                  (let ((a_n (for/first ((i (in-naturals 4))
                                         #:unless (hash-has-key? rev# i)
                                         #:when (and (= (gcd i (a098550 (- n 1))) 1)
                                                     (> (gcd i (a098550 (- n 2))) 1)))
                               i)))
                    (hash-set! hsh# n a_n)
                    (hash-set! rev# a_n n)
                    a_n))))))

(map a098550 (range 1 (add1 30)))

(plot (points
       (map (λ (i) (vector i (a098550 i))) (range 1 (add1 100)))))
