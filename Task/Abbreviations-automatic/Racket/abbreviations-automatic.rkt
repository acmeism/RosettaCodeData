#lang racket

(require racket/set)

(define (abbr-length ss)
  (for*/first ((l (in-range 1 (string-length (argmax string-length ss))))
               #:when (equal? (sequence-length
                               (for/set ((s ss))
                                 (substring s 0 (min l (string-length s)))))
                              (length ss)))
    l))

(module+ main
  (define report-line
    (match-lambda
      ["" ""]
      [(and s (app string-split ss)) (format "~a ~a" (abbr-length ss) s)]))
  (for-each (compose displayln report-line) (take (file->lines "data.txt") 5)))
