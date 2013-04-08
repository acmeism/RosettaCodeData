(flip
   (by length sort
      (by '((L) (sort (copy L))) group
         (in "unixdict.txt" (make (while (line) (link @)))) ) ) )
