(class +BoundedInt)
# value lower upper

(dm T (Low Up)
   (=: lower (min Low Up))
   (=: upper (max Low Up)) )

(de "checkBounds" (Val)
   (if (>= (: upper) Val (: lower))
      Val
      (throw 'boundedIntOutOfBounds
         (pack
            "value " Val
            " is out of bounds [" (: lower) "," (: upper) "]" ) ) ) )

(dm set> (Val)
   (=: value ("checkBounds" Val)) )

(dm +> (Val)
   (=: value ("checkBounds" (+ Val (: value)))) )

(dm val> ()
   (: value) )

(de main ()
   (let (A (new '(+BoundedInt) 1 10)  B (new '(+BoundedInt) 1 10))
      (set> A 6)
      (when (catch 'boundedIntOutOfBounds (set> B 12) NIL)
         (prinl @) )
      (set> B 9)
      (when (catch 'boundedIntOutOfBounds (+> A (val> B)) NIL)
         (prinl @) ) ) )
