#lang racket

(define (first-non-matching-index l =)
  (and (not (null? l)) (index-where l (curry (negate =) (car l)))))

(define (report-string-sameness s)
  (printf "~s (length: ~a): ~a~%"
          s
          (string-length s)
          (cond [(first-non-matching-index (string->list s) char=?)
                 => (λ (i)
                      (let ((c (string-ref s i)))
                        (format "first different character ~s(~a) at position: ~a" c (char->integer c) (add1 i))))]
                [else "all characters are the same"])))

(module+ test
  (for-each report-string-sameness '("" "   " "2" "333" ".55" "tttTTT" "4444 444k")))
