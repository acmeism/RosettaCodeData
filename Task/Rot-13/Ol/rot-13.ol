(import (scheme char))

(define (rot13 str)
   (runes->string (map (lambda (ch)
         (+ ch (cond
                  ((char-ci<=? #\a ch #\m)
                     13)
                  ((char-ci<=? #\n ch #\z)
                     -13)
                  (else 0))))
      (string->runes str))))

(define str "`What a curious feeling!' said Alice; `I must be shutting up like a telescope.'")
(print (rot13 str))
(print (rot13 (rot13 str)))
