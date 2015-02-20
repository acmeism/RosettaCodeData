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

(println
   (modinv 42 2017) )

(bye)
