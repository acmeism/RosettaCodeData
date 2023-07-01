#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(load "@lib/misc.l")

(in (opt)
   (until (eof)
      (let Lst (split (line) "^I")
         (unless
            (and
               (= 49 (length Lst))     # Check total length
               ($dat (car Lst) "-")    # Check for valid date
               (fully                  # Check data format
                  '((L F)
                     (if F                         # Alternating:
                        (format L 3)               # Number
                        (>= 9 (format L) -9) ) )   # or flag
                  (cdr Lst)
                  '(T NIL .) ) )
            (prinl "Bad line format: " (glue " " Lst))
            (bye 1) ) ) ) )

(bye)
