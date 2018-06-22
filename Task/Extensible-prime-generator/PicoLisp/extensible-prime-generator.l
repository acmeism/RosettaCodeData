(de prime? (N Lst)
   (let S (sqrt N)
      (for D Lst
         (T (> D S) T)
         (T (=0 (% N D)) NIL) ) ) )
(de primeseq (A B)
   (let (I 1 R)
      (nth
         (make
            (link 2)
            (while (> A (inc 'I 2))
               (and (prime? I (made)) (link I)) )
            (setq R (length (made)))
            (while (> B I)
               (and (prime? I (made)) (link I))
               (inc 'I 2) ) )
         (inc R) ) ) )
(de take (N)
   (let I 1
      (make
         (link 2)
         (do (dec N)
            (until (prime? (inc 'I 2) (made)))
            (link I) ) ) ) )

(prin "First 20 primes: ")
(println (take 20))
(prin "Primes between 100 and 150: ")
(println (primeseq 100 150))
(prinl
   "Number of primes between 7700 and 8000: "
   (length (primeseq 7700 8000)) )
(for N (10 100 1000 10000 100000 1000000)
   (prinl
      N
      "th prime: "
      (last (take N)) ) )
