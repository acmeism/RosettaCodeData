(import (otus random!))

(call/cc (lambda (break)
   (let loop ()
      (if (= (rand! 20) 10)
         (break #t))
      (print (rand! 20))
      (loop))))
