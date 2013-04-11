(let Dir "."
   (recur (Dir)
      (for F (dir Dir)
         (let Path (pack Dir "/" F)
            (cond
               ((=T (car (info Path)))             # Is a subdirectory?
                  (recurse Path) )                 # Yes: Recurse
               ((match '`(chop "s@.l") (chop F))   # Matches 's*.l'?
                  (println Path) ) ) ) ) ) )       # Yes: Print it
