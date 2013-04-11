(de rot13-Ch (C)
   (cond
      ((>= "M" (uppc C) "A")
         (char (+ (char C) 13)) )
      ((>= "Z" (uppc C) "N")
         (char (- (char C) 13)) )
      (T C) ) )
