(import (otus random!))

(for-each (lambda (str)
      (define timeout (rand! 999))
      (async (lambda ()
         (sleep timeout)
         (print str))))
   '("Enjoy" "Rosetta" "Code"))
