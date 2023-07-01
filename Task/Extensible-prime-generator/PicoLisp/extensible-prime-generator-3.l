(prin "The first 20 primes: ")
(do 20 (printsp (primes T)))
(prinl)

(prin "between 100 and 150: ")
(while (< (setq P (primes T)) 150)
   (when (> P 100)
      (printsp P)))
(prinl)

(setq Count 0)
(while (< (setq P (primes T)) 8000)
   (when (> P 7700)
      (inc 'Count)))
(prinl "There are " Count " primes between 7700 and 8000.")

(de nthprime (N)
   (primes NIL)
   (do (dec N)
      (primes T))
   (primes T))

(de comma_fmt (N) (format N 0 "." ","))

(prinl "nth prime:")
(for N (10 100 1000 10000 100000 1000000)
   (prinl (align 9 (comma_fmt N)) " " (align 12 (comma_fmt (nthprime N)))))
(bye)
