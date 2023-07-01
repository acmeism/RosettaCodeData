#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(let Lang '("ada" "awk" "c" "forth" "prolog" "python" "z80")
   (in NIL
      (while (echo "<")
         (let S (till ">" T)
            (cond
               ((pre? "code " S) (prin "<lang" (cddddr (chop S))))
               ((member S Lang) (prin "<lang " S))
               ((= S "/code") (prin "</lang"))
               ((and (pre? "/" S) (member (pack (cdr (chop S))) Lang))
                  (prin "</lang") )
               (T (prin "<" S)) ) ) ) ) )
(bye)
