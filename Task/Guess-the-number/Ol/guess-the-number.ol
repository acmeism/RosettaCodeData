(import (otus random!))

(define number (+ 1 (rand! 10)))
(let loop ()
   (display "Pick a number from 1 through 10: ")
   (if (eq? (read) number)
      (print "Well guessed!")
      (loop)))
