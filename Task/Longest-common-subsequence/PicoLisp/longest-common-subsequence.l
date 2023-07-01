(de commonSequences (A B)
   (when A
      (conc
         (when (member (car A) B)
            (mapcar '((L) (cons (car A) L))
               (cons NIL (commonSequences (cdr A) (cdr @))) ) )
         (commonSequences (cdr A) B) ) ) )

(maxi length
   (commonSequences
      (chop "thisisatest")
      (chop "testing123testing") ) )
