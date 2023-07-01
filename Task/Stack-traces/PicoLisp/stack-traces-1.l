(off "Stack")

(de $$ "Prg"
   (let "Stack" (cons (cons (car "Prg") (env)) "Stack")  # Build stack frame
      (set "Stack"
         (delq (asoq '"Stack" (car "Stack"))  # Remove self-created entries
            (delq (asoq '"Prg" (car "Stack"))
               (car "Stack") ) ) )
      (run (cdr "Prg")) ) )  # Run body

(de stackAll (Excl)
   (let *Dbg NIL
      (for "X" (all)
         (or
            (memq "X" Excl)
            (memq "X" '($$ @ @@ @@@))
            (= `(char "*") (char "X"))
            (cond
               ((= `(char "+") (char "X"))
                  (for "Y" (pair (val "X"))
                     (and
                        (pair "Y")
                        (fun? (cdr "Y"))
                        (unless (== '$$ (caaddr "Y"))
                           (con (cdr "Y")
                              (list
                                 (cons '$$ (cons (car "Y" "X") (cddr "Y"))) ) ) ) ) ) )
               ((pair (getd "X"))
                  (let "Y" @
                     (unless (== '$$ (caadr "Y"))
                        (con "Y"
                           (list (cons '$$ "X" (cdr "Y"))) ) ) ) ) ) ) ) ) )

(de dumpStack ()
   (more (reverse (cdr "Stack")))
   T )
