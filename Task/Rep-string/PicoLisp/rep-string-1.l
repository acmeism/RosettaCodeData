(de repString (Str)
   (let Lst (chop Str)
      (for (N (/ (length Lst) 2)  (gt0 N)  (dec N))
         (T
            (use (Lst X)
               (let H (cut N 'Lst)
                  (loop
                     (setq X (cut N 'Lst))
                     (NIL (head X H))
                     (NIL Lst T) ) ) )
            N ) ) ) )
