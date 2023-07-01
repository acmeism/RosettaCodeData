(co 'fibo
   (let (A 0  B 1)
      (yield 'ready)
      (while
         (yield
            (swap 'B (+ (swap 'A B) B)) ) ) ) )

(do 15
   (printsp (yield 'next 'fibo)) )
(prinl)
(yield NIL 'fibo)
