(de hq9+ (Code)
   (let Accu 0
      (for C (chop Code)
         (case C
            ("H" (prinl "Hello, world"))
            ("Q" (prinl Code))
            ("9"
               (for (N 99 (gt0 N))
                  (prinl N " bottles of beer on the wall")
                  (prinl N " bottles of beer")
                  (prinl "Take one down, pass it around")
                  (prinl (dec 'N) " bottles of beer on the wall")
                  (prinl) ) )
            ("+" (inc 'Accu)) ) )
      Accu ) )
