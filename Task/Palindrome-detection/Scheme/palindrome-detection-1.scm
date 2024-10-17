(define (palindrome? s)
  (let ((chars (string->list s)))
    (equal? chars (reverse chars))))
