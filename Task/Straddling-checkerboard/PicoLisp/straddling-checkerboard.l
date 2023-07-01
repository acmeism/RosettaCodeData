(de *Straddling
   (NIL  "H"  "O"  "L"  NIL  "M"  "E"  "S"  NIL  "R"  "T")
   ("3"  "A"  "B"  "C"  "D"  "F"  "G"  "I"  "J"  "K"  "N")
   ("7"  "P"  "Q"  "U"  "V"  "W"  "X"  "Y"  "Z"  "."  "/")
   ("79" "0"  "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9") )

(de straddle (Str)
   (pack
      (mapcar
         '((C)
            (pick
               '((L)
                  (and
                     (index C (cdr L))
                     (cons (car L) (dec @)) ) )
               *Straddling ) )
         (chop (uppc Str)) ) ) )

(de unStraddle (Str)
   (pack
      (make
         (for (L (chop Str)  L)
            (let C (pop 'L)
               (setq C
                  (if (assoc C *Straddling)
                     (get (cdr @) (inc (format (pop 'L))))
                     (get (cdar *Straddling) (inc (format C))) ) )
               (link (if (= "/" C) (pop 'L) C)) ) ) ) ) )
