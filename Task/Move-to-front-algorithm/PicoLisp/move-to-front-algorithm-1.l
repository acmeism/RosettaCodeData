(de encode (Str)
   (let Table (chop "abcdefghijklmnopqrstuvwxyz")
      (mapcar
         '((C)
            (dec
               (prog1
                  (index C Table)
                  (rot Table @) ) ) )
         (chop Str) ) ) )

(de decode (Lst)
   (let Table (chop "abcdefghijklmnopqrstuvwxyz")
      (pack
         (mapcar
            '((N)
               (prog1
                  (get Table (inc 'N))
                  (rot Table N) ) )
            Lst ) ) ) )
