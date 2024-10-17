(define (fizzbuzz x)
  (let ([words '((3 . "Fizz")
                 (5 . "Buzz"))])
    (define (fbm x)
      (let ([w (map cdr (filter (lambda (wo) (= 0 (modulo x (car wo)))) words))])
        (if (null? w) x (apply string-append w))))
    (for-each (cut format #t "~a~%" <>) (map fbm (iota x 1 1)))))

(fizzbuzz 15)
