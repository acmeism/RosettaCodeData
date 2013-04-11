(de beadSort (Lst)
   (let Abacus (cons NIL)
      (for N Lst                                   # Thread beads on poles
         (for (L Abacus  (ge0 (dec 'N))  (cdr L))
            (or (cdr L) (queue 'L (cons)))
            (push (cadr L) T) ) )
      (make
         (while (gt0 (cnt pop (cdr Abacus)))       # Drop and count beads
            (link @) ) ) ) )
