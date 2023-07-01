(de comma_fmt (N) (format N 0 "." ","))

(de prime-td? (N Chk)
   (let (D NIL  Rt (sqrt N))
      (loop
         (NIL Chk T) # if we run out of test divisors then it's prime.
         (setq D (pop 'Chk))
         (T (> D Rt) T)
         (T (=0 (% N D)) NIL))))

(de primes (Run?)
   (if (not Run?)
      (co 'primegen) # stop
      (co 'primegen
         (yield 2)
         (yield 3)
         (make
            (chain (3 1 2))  # start with W1 = 1, 3, 5, 7, 9, ...
            (loop
               # At the start of the loop, switch to the next size wheel.
               (let
                  ((Sj . Wheel) (made)  # current wheel (size & spokes)
                     P (cadr Wheel)     # current sieving prime
                     Sk (* P Sj) )      # size of next wheel
                  (made (list Sk))
                  (chain
                     (filter '((N) (n0 (% N P))) Wheel))
                  (for (O Sj (< O Sk) (+ O Sj))
                     (for W Wheel
                        (let N (+ O W)
                           (when (n0 (% N P))
                              (link N)
                              (when (prime-td? N (cdr Wheel))
                                 (yield N))))))))))))

(do 31 (prin (primes T) " ")) (prinl)
(primes NIL)
(do 10000 (primes T))
(prinl "The 10,001st prime is " (comma_fmt (primes T)))
(bye)
