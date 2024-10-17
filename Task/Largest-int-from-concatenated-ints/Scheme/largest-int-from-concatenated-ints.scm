(define (cat . nums)  (apply string-append (map number->string nums)))

(define (my-compare a b)  (string>? (cat a b) (cat b a)))

(map  (lambda (xs) (string->number (apply cat (sort xs my-compare))))
      '((1 34 3 98 9 76 45 4) (54 546 548 60)))
