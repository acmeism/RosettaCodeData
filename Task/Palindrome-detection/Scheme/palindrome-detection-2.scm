(define (palindrome? s)
  (let loop ((i 0)
             (j (- (string-length s) 1)))
    (or (>= i j)
        (and (char=? (string-ref s i) (string-ref s j))
             (loop (+ i 1) (- j 1))))))

;; Or:
(define (palindrome? s)
  (let loop ((s (string->list s))
             (r (reverse (string->list s))))
    (or (null? s)
        (and (char=? (car s) (car r))
             (loop (cdr s) (cdr r))))))

> (palindrome? "ingirumimusnocteetconsumimurigni")
#t
> (palindrome? "This is not a palindrome")
#f
>
