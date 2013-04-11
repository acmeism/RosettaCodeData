(de multisplit (Str Sep)
   (setq Sep (mapcar chop Sep))
   (make
      (for (S (chop Str) S)
         (let L
            (make
               (loop
                  (T (find head Sep (circ S))
                     (link
                        (list
                           (- (length Str) (length S))
                           (pack (cut (length @) 'S)) ) ) )
                  (link (pop 'S))
                  (NIL S (link NIL)) ) )
            (link (pack (cdr (rot L))))
            (and (car L) (link @)) ) ) ) )

(println (multisplit "a!===b=!=c" '("==" "!=" "=")))
(println (multisplit "a!===b=!=c" '("=" "!=" "==")))
