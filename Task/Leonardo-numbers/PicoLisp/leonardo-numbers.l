(de leo (A B C)
   (default A 1  B 1  C 1)
   (make
      (do 25
         (inc
            'B
            (+ (link (swap 'A B)) C) ) ) ) )

(println 'Leonardo (leo))
(println 'Fibonacci (leo 0 1 0))
