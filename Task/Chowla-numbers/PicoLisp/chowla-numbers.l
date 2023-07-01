(de accu1 (Var Key)
   (if (assoc Key (val Var))
      (con @ (inc (cdr @)))
      (push Var (cons Key 1)) )
   Key )
(de factor (N)
   (let
      (R NIL
         D 2
         L (1 2 2 . (4 2 4 2 4 6 2 6 .))
         M (sqrt N) )
      (while (>= M D)
         (if (=0 (% N D))
            (setq M
               (sqrt (setq N (/ N (accu1 'R D)))) )
            (inc 'D (pop 'L)) ) )
      (accu1 'R N)
      (mapcar
         '((L)
            (make
               (for N (cdr L)
                  (link (** (car L) N)) ) ) )
         R ) ) )
(de chowla (N)
   (let F (factor N)
      (-
         (sum
            prog
            (make
               (link 1)
               (mapc
                  '((A)
                     (chain
                        (mapcan
                           '((B)
                              (mapcar '((C) (* C B)) (made)) )
                           A ) ) )
                  F ) ) )
         N
         1 ) ) )
(de prime (N)
   (and (> N 1) (=0 (chowla N))) )
(de perfect (N)
   (and
      (> N 1)
      (= (chowla N) (dec N))) )
(de countP (N)
   (let C 0
      (for I N
         (and (prime I) (inc 'C)) )
      C ) )
(de listP (N)
   (make
      (for I N
         (and (perfect I) (link I)) ) ) )
(for I 37
   (prinl "chowla(" I ") = " (chowla I)) )
(prinl "Count of primes up to      100 = " (countP 100))
(prinl "Count of primes up to     1000 = " (countP 1000))
(prinl "Count of primes up to    10000 = " (countP 10000))
(prinl "Count of primes up to   100000 = " (countP 100000))
(prinl "Count of primes up to  1000000 = " (countP 1000000))
(prinl "Count of primes up to 10000000 = " (countP 10000000))
(println (listP 35000000))
