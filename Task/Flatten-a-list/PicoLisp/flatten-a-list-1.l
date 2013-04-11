(de flatten (X)
   (make                               # Build a list
      (recur (X)                       # recursively over 'X'
         (if (atom X)
            (link X)                   # Put atoms into the result
            (mapc recurse X) ) ) ) )   # or recurse on sub-lists
