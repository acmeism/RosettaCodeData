(for F (dir "@src/")                         # Iterate directory
   (when (match '`(chop "s@.c") (chop F))    # Matches 's*.c'?
      (println F) ) )                        # Yes: Print it
