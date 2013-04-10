(in "unixdict.txt"
   (mapc prinl
      (maxi '((L) (length (car L)))
         (by length group
            (filter '((S) (apply <= S))
               (make (while (line) (link @))) ) ) ) ) )
