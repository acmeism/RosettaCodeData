;; returns #t or #f
(define (palindrome? string)
(equal? (string->list string) (reverse (string->list string))))

;; to strip spaces, use the following
;;(define (palindrome? string)
;;(let ((string (string-replace string "/\ /" "" "g")))
;;(equal? (string->list string) (reverse (string->list string)))))
