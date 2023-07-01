(de braceExpand (Str)
   (let Lst
      (make
         (for (Lst (chop Str)  Lst)
            (case (pop 'Lst)
               ("\\" (link (pop 'Lst)))
               ("{"
                  (recur ()
                     (let L
                        (make
                           (while
                              (case (pop 'Lst)
                                 ("\\" (link (pop 'Lst)) Lst)
                                 ("{" (recurse) Lst)
                                 ("}" NIL)
                                 ("," (link 0) Lst)  # Replace commata with '0'
                                 (T (link @) Lst) ) ) )
                        (if (= "}" @)  # Was closing brace
                           (if (member 0 L)  # Has comma(ta)
                              (link (split L 0))
                              (chain (list "{") (replace L 0 ",") (list "}")))
                           (chain (list "{") (replace L 0 ",")) ) ) ) )
               (T (link @)) ) ) )
      (recur (Lst)
         (ifn (find pair Lst)
            (list (pack Lst))
            (let R (recurse (cdr Lst))
               (mapcan
                  '((A) (mapcar '((B) (pack A B)) R))
                  (if (pair (car Lst))
                     (mapcan recurse (car Lst))
                     (list (car Lst)) ) ) ) ) ) ) )
