(define (replace-in-file filename this bythat)
   (set 'content (read-file filename))
   (when (string? content)
     (replace this content bythat)
     (write-file filename content)
   )
)

(set 'files '("a.txt" "b.txt" "c.txt" "missing"))
(dolist (fname files)
   (replace-in-file fname "Goodbye London!" "Hello New York!")
)

(exit)
