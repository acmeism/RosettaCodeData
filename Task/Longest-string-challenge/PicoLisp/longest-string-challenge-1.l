(mapc prinl
   (maxi '((L) (length (car L)))
      (by length group
         (in NIL
            (make (until (eof) (link (line)))) ) ) ) )
