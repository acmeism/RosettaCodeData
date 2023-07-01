(de choose (Prompt Items)
   (use N
      (loop
         (for (I . Item) Items
            (prinl I ": " Item) )
         (prin Prompt " ")
         (flush)
         (NIL (setq N (in NIL (read))))
         (T (>= (length Items) N 1) (prinl (get Items N))) ) ) )
(choose "Which is from the three pigs?"
   '("fee fie" "huff and puff" "mirror mirror" "tick tock") )
