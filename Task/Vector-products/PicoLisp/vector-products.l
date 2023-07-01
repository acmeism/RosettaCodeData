(de dotProduct (A B)
   (sum * A B) )

(de crossProduct (A B)
   (list
      (- (* (cadr A) (caddr B)) (* (caddr A) (cadr B)))
      (- (* (caddr A) (car B)) (* (car A) (caddr B)))
      (- (* (car A) (cadr B)) (* (cadr A) (car B))) ) )

(de scalarTriple (A B C)
   (dotProduct A (crossProduct B C)) )

(de vectorTriple (A B C)
   (crossProduct A (crossProduct B C)) )
