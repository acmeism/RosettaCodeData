(import (lib sha1))
(define (->string value)
   (runes->string
   (let ((L "0123456789abcdef"))
   (let loop ((v value))
      (if (null? v) null
      (cons
         (string-ref L (>> (car v) 4))
         (cons
         (string-ref L (band (car v) #xF))
            (loop (cdr v)))))))))

(print (->string (sha1:digest "Rosetta Code")))
> 48c98f7e5a6e736d790ab740dfc3f51a61abe2b5
(print (->string (sha1:digest "")))
> da39a3ee5e6b4b0d3255bfef95601890afd80709
