(de commonPath (Lst Chr)
   (glue Chr
      (make
         (apply find
            (mapcar '((L) (split (chop L) Chr)) Lst)
            '(@ (or (pass <>) (nil (link (next))))) ) ) ) )
