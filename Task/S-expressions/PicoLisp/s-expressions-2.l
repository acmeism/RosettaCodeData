(de readSexpr ()
   (case (skip)
      ("(" (char) (readList))
      ("\"" (char) (readString))
      (T (readAtom)) ) ) )

(de readList ()
   (make
      (loop
         (NIL (skip))
         (T (= @ ")") (char))
         (link (readSexpr)) ) ) )

(de readString ()
   (pack
      (make
         (until (= "\"" (or (peek) (quit "Unterminated string")))
            (link (char)) )
         (char) ) ) )

(de readAtom ()
   (let X
      (make
         (until (or (sp? (peek)) (member (peek) '("(" ")")))
            (link (char)) ) )
      (or (format X) (intern (pack X))) ) )
