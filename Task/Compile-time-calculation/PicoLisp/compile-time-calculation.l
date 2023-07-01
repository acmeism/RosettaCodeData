(de fact (N)
   (apply * (range 1 N)) )

(de foo ()
   (prinl "The value of fact(10) is " `(fact 10)) )
