#lang racket

(define (read+write)
  (for ([line (in-lines)])
    (define a (substring line 0 5))
    (define n (string->number (string-append (substring line 14 15)
                                             (substring line 10 14))))
    (printf "~a~aXXXXX\n" a (~a n #:min-width 5 #:align 'right))))

(with-output-to-file "selective-output.txt" #:mode 'text #:exists 'replace
  (thunk (with-input-from-file "selective-input.txt" read+write)))
