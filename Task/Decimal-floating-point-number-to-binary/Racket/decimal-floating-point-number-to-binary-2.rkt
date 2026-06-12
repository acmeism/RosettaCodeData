(define (number->string/binary x)
  (define decimals-places 10)
  (define digits-all (~r (inexact->exact (round (* x (expt 2 decimals-places))))
                         #:base 2
                         #:pad-string "0"
                         #:min-width (add1 decimals-places)))
  (define digits-length (string-length digits-all))
  (define integer-part (substring digits-all 0 (- digits-length decimals-places)))
  (define decimal-part* (string-trim (substring digits-all (- digits-length decimals-places))
                                    "0"
                                    #:left? #f
                                    #:repeat? #t))
  (define decimal-part (if (string=? decimal-part* "") "0"  decimal-part*))
  (string-append integer-part "." decimal-part))


(number->string/binary 9.01)
(number->string/binary 9)
(number->string/binary 0.01)
(newline)
