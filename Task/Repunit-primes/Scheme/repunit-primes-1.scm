; Test whether any integer is a probable prime.
(define prime<probably>?
  (lambda (n)
    ; Fast modular exponentiation.
    (define modexpt
      (lambda (b e m)
        (cond
          ((zero? e) 1)
          ((even? e) (modexpt (mod (* b b) m) (div e 2) m))
          ((odd? e) (mod (* b (modexpt b (- e 1) m)) m)))))
    ; Return multiple values s, d such that d is odd and 2^s * d = n.
    (define split
      (lambda (n)
        (let recur ((s 0) (d n))
          (if (odd? d)
            (values s d)
            (recur (+ s 1) (div d 2))))))
    ; Test whether the number a proves that n is composite.
    (define composite-witness?
      (lambda (n a)
        (let*-values (((s d) (split (- n 1)))
                      ((x) (modexpt a d n)))
          (and (not (= x 1))
               (not (= x (- n 1)))
               (let try ((r (- s 1)))
                 (set! x (modexpt x 2 n))
                 (or (zero? r)
                     (= x 1)
                     (and (not (= x (- n 1)))
                          (try (- r 1)))))))))
    ; Test whether n > 2 is a Miller-Rabin pseudoprime, k trials.
    (define pseudoprime?
      (lambda (n k)
        (or (zero? k)
            (let ((a (+ 2 (random (- n 2)))))
              (and (not (composite-witness? n a))
                   (pseudoprime? n (- k 1)))))))
    ; Compute and return Probable Primality using the Miller-Rabin algorithm.
    (and (> n 1)
         (or (= n 2)
             (and (odd? n)
                  (pseudoprime? n 50))))))
