(let Freq NIL
   (for "L" (filter pair (extract getd (all)))
      (for "F"
         (filter atom
            (fish '((X) (or (circ? X) (getd X)))
               "L" ) )
         (accu 'Freq "F" 1) ) )
   (for X (head 10 (flip (by cdr sort Freq)))
      (tab (-7 4) (car X) (cdr X)) ) )
