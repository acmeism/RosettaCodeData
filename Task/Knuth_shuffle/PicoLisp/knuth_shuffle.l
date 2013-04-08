(de shuffle (Lst)
   (make
      (for (N (length Lst) (gt0 N))
         (setq Lst
            (conc
               (cut (rand 0 (dec 'N)) 'Lst)
               (prog (link (car Lst)) (cdr Lst)) ) ) ) ) )
