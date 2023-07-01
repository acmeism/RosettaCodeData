(let Data  # Read all data
   (in "config"
      (make
         (until (eof)
            (link (trim (split (line) " "))) ) ) )
   (setq Data  # Fix comments
      (mapcar
         '((L)
            (while (head '(";" ";") (car L))
               (pop L) )
            (if (= '(";") (car L))
               L
               (cons NIL L) ) )
         Data ) )
   (let (Need NIL  Seed NIL  NBan NIL  NStr NIL  Favo NIL)
      (map
         '((L)
            (let D (mapcar uppc (cadar L))
               (cond
                  ((= '`(chop "NEEDSPEELING") D)
                     (if Need
                        (set L)
                        (on Need)
                        (unless (caar L)
                           (set (car L) '(";")) ) ) )
                  ((= '`(chop "SEEDSREMOVED") D)
                     (if Seed
                        (set L)
                        (on Seed)
                        (when (caar L)
                           (set (car L)) ) ) )
                  ((= '`(chop "NUMBEROFBANANAS") D)
                     (if NBan
                        (set L)
                        (on NBan)
                        (set (cddar L) 1024) ) )
                  ((= '`(chop "NUMBEROFSTRAWBERRIES") D)
                     (if NStr
                        (set L)
                        (on NStr) ) )
                  ((= '`(chop "FAVOURITEFRUIT") D)
                     (if Favo
                        (set L)
                        (on Favo) ) ) ) ) )
         Data )
      (unless Need
         (conc Data (cons (list NIL "NEEDSPEELING"))) )
      (unless Seed
         (conc Data (cons (list NIL "SEEDSREMOVED"))) )
      (unless NBan
         (conc Data (cons (list NIL "NUMBEROFBANANAS" 1024))) )
      (unless NStr
         (conc Data (cons (list NIL "NUMBEROFSTRAWBERRIES" 62000))) ) )
   (out "config"
      (for L Data
         (prinl (glue " " (if (car L) L (cdr L)))) ) ) )
