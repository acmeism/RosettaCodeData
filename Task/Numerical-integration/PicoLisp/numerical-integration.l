(scl 6)

(de leftRect (Fun X)
   (Fun X) )

(de rightRect (Fun X H)
   (Fun (+ X H)) )

(de midRect (Fun X H)
   (Fun (+ X (/ H 2))) )

(de trapezium (Fun X H)
   (/ (+ (Fun X) (Fun (+ X H))) 2) )

(de simpson (Fun X H)
   (*/
      (+
         (Fun X)
         (* 4 (Fun (+ X (/ H 2))))
         (Fun (+ X H)) )
      6 ) )

(de square (X)
   (*/ X X 1.0) )

(de integrate (Fun From To Steps Meth)
   (let (H (/ (- To From) Steps)  Sum 0)
      (for (X From  (>= (- To H) X)  (+ X H))
         (inc 'Sum (Meth Fun X H)) )
      (*/ H Sum 1.0) ) )

(prinl (round (integrate square 3.0 7.0 30 simpson)))
