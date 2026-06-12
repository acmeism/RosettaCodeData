(de record (F)
   (in F
      (until (eof)
         (tab (5 5 5)
            (make (do 5 (link (char))))
            (and
               (do 5
                  (char) )
               (till "+-")
               (format (conc (cons (peek)) @)) )
            "XXXXX" )
         (line) ) ) )

(record "selective.in")
