(define content (bytes->string
   (vec-iter
      (file->vector "file.txt"))))

(print content)
