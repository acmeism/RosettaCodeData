(be number (@N @Max)
   (^ @C (box 0))
   (repeat)
   (or
      ((^ @ (>= (val (-> @C)) (-> @Max))) T (fail))
      ((^ @N (inc (-> @C)))) ) )

(be + (@A @B @Sum)
   (^ @ (-> @A))
   (^ @ (-> @B))
   (^ @Sum (+ (-> @A) (-> @B))) )

(be + (@A @B @Sum)
   (^ @ (-> @A))
   (^ @ (-> @Sum))
   (^ @B (- (-> @Sum) (-> @A)))
   T
   (^ @ (ge0 (-> @B))) )

(be + (@A @B @Sum)
   (number @A @Sum)
   (^ @B (- (-> @Sum) (-> @A))) )

#{
         151
        A   B
      40  C   D
     E  F  G    H
   X  11  Y   4   Z
}#

(be puzzle (@X @Y @Z)
   (+ @A @B 151)
   (+ 40 @C @A)
   (+ @C @D @B)
   (+ @E @F 40)
   (+ @F @G @C)
   (+ @G @H @D)
   (+ @X 11 @E)
   (+ 11 @Y @F)
   (+ @Y 4 @G)
   (+ 4 @Z @H)
   (+ @X @Z @Y)
   T )
