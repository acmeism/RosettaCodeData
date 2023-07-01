(define (harsh? n)
    (zero? (modulo n
        (apply + (map string->number (string->list (number->string n)))))))

(harsh? 42)
    → #t

(define H (stream-filter harsh? (in-naturals 1)))

(take H 20)
    → (1 2 3 4 5 6 7 8 9 10 12 18 20 21 24 27 30 36 40 42)

(for ((n H)) #:break (> n 1000) => n)
    → 1002
