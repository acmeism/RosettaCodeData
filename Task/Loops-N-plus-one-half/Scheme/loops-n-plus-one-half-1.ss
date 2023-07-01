(call-with-current-continuation
 (lambda (esc)
   (do ((i 1 (+ 1 i))) (#f)
     (display i)
     (if (= i 10) (esc (newline)))
     (display ", "))))
