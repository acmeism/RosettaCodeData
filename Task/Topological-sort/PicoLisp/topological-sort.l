(de sortDependencies (Lst)
   (setq Lst                              # Build a flat list
      (uniq
         (mapcan
            '((L)
               (put (car L) 'dep (cdr L)) # Store dependencies in 'dep' properties
               (copy L) )
            (mapcar uniq Lst) ) ) )       # without self-dependencies
   (make
      (while Lst
         (ifn (find '((This) (not (: dep))) Lst)   # Found non-depending lib?
            (quit "Can't resolve dependencies" Lst)
            (del (link @) 'Lst)                    # Yes: Store in result
            (for This Lst                          # and remove from 'dep's
               (=: dep (delete @ (: dep))) ) ) ) ) )
