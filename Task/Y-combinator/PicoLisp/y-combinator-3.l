# Fibonacci
(de fibo (F)
   (curry (F) (N)
      (if (> 2 N)
         1
         (+ (F (dec N)) (F (- N 2))) ) ) )

: ((Y fibo) 22)
-> 28657
