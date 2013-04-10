(de bestShuffle (Str)
   (let Lst NIL
      (for C (setq Str (chop Str))
         (if (assoc C Lst)
            (con @ (cons C (cdr @)))
            (push 'Lst (cons C)) ) )
      (setq Lst (apply conc (flip (by length sort Lst))))
      (let Res
         (mapcar
            '((C)
               (prog1 (or (find <> Lst (circ C)) C)
                  (setq Lst (delete @ Lst)) ) )
            Str )
         (prinl Str " " Res " (" (cnt = Str Res) ")") ) ) )
