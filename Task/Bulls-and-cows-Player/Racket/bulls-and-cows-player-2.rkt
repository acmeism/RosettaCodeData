 (define (parse-score score)
  (if (string? score)
      (let ([splited-score (string-split score ",")])
        (if (= (length (string-split score ",")) 2)
            (apply values (map (lambda (s) (string->number (string-trim s))) splited-score))
            (values #f #f)))
      (values #f #f)))

(define (calculate-score guess chosen)
  (define (in-chosen x) (member x chosen))
  (let ([bulls (count = guess chosen)]
        [cows+bulls (count in-chosen guess)])
    (values bulls (- cows+bulls bulls))))
