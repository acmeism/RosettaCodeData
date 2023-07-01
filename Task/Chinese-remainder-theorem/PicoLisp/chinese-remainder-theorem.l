(de modinv (A B)
   (let (B0 B  X0 0  X1 1  Q 0  T1 0)
      (while (< 1 A)
         (setq
            Q (/ A B)
            T1 B
            B (% A B)
            A T1
            T1 X0
            X0 (- X1 (* Q X0))
            X1 T1 ) )
      (if (lt0 X1) (+ X1 B0) X1) ) )

(de chinrem (N A)
   (let P (apply * N)
      (%
         (sum
            '((N A)
               (setq T1 (/ P N))
               (* A (modinv T1 N) T1) )
            N
            A )
         P ) ) )

(println
   (chinrem (3 5 7) (2 3 2))
   (chinrem (11 12 13) (10 4 12)) )

(bye)
