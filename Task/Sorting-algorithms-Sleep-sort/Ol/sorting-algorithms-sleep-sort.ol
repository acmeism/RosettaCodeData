(define (sleep-sort lst)
   (for-each (lambda (timeout)
         (async (lambda ()
            (sleep timeout)
            (print timeout))))
      lst))

(sleep-sort '(5 8 2 7 9 10 5))
