(de halfAdder (A B)  #> (Carry . Sum)
   (cons
      (and A B)
      (xor A B) ) )

(de fullAdder (A B C)  #> (Carry . Sum)
   (let (Ha1 (halfAdder C A)  Ha2 (halfAdder (cdr Ha1) B))
      (cons
         (or (car Ha1) (car Ha2))
         (cdr Ha2) ) ) )

(de 4bitsAdder (A4 A3 A2 A1  B4 B3 B2 B1)  #> (V S4 S3 S2 S1)
   (let
      (Fa1 (fullAdder A1 B1)
         Fa2 (fullAdder A2 B2 (car Fa1))
         Fa3 (fullAdder A3 B3 (car Fa2))
         Fa4 (fullAdder A4 B4 (car Fa3)) )
      (list
         (car Fa4)
         (cdr Fa4)
         (cdr Fa3)
         (cdr Fa2)
         (cdr Fa1) ) ) )
