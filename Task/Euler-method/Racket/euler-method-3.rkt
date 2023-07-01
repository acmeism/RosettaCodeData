(define (iterate-while test f x)
  (let next ([result x]
             [list-of-results '()])
    (if (apply test result)
        (next (apply f result) (cons result list-of-results))
        list-of-results)))
