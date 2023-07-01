# Factorial
(de fact (F)
   (curry (F) (N)
      (if (=0 N)
         1
         (* N (F (dec N))) ) ) )

: ((Y fact) 6)
-> 720
