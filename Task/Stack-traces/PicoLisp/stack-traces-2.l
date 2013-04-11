(de foo (A B)
   (let C 3
      (bar (inc 'A) (inc 'B) (inc 'C)) ) )

(de bar (A D E)
   (let (A 7  B 8  C 9)
      (! println A B C) ) )  # Set a breakpoint before (println A B C)

(stackAll)
