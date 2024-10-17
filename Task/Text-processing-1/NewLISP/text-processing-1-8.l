(define (get-day day)
  (filter (fn(e) (= day (e 1))) (array-list all-readings)))

(get-day "1993-03-05")
