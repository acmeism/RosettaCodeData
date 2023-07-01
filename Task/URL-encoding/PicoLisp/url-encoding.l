(de urlEncodeTooMuch (Str)
   (pack
      (mapcar
         '((C)
            (if (or (>= "9" C "0") (>= "Z" (uppc C) "A"))
               C
               (list '% (hex (char C))) ) )
         (chop Str) ) ) )
