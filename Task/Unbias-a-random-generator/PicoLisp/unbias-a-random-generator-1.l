(de randN (N)
   (if (= 1 (rand 1 N)) 1 0) )

(de unbiased (N)
   (use (A B)
      (while
         (=
            (setq A (randN N))
            (setq B (randN N)) ) )
      A ) )
