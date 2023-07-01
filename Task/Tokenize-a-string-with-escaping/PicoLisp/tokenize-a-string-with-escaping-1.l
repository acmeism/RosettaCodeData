(de tokenize (Str Sep Esc)
   (split
      (make
         (for (L (chop Str)  L)
            (let C (pop 'L)
               (cond
                  ((= C Esc) (link (pop 'L)))
                  ((= C Sep) (link 0))
                  (T (link C)) ) ) ) )
      0 ) )
