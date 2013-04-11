(de sortTable (Tbl . @)
   (let (Ordering prog  Column 1  Reverse NIL)  # Set defaults
      (bind (rest)                              # Bind optional params
         (setq Tbl
            (by '((L) (Ordering (get L Column)))
               sort
               Tbl ) )
         (if Reverse (flip Tbl) Tbl) ) ) )
