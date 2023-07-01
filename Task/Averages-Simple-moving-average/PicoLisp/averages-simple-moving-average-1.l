(de sma (@Len)
   (curry (@Len (Data)) (N)
      (push 'Data N)
      (and (nth Data @Len) (con @))  # Truncate
      (*/ (apply + Data) (length Data)) ) )
