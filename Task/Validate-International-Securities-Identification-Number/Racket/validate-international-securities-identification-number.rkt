#lang racket

;; convert a base36 character (#\0 - #\Z) to its equivalent
;; in base 10 as a string ("0" - "35")
(define (base36-char->base10-string c)
  (let ([char-int (char->integer (char-upcase c))]
        [zero-int (char->integer #\0)]
        [nine-int (char->integer #\9)]
        [A-int (char->integer #\A)]
        [Z-int (char->integer #\Z)])
    (cond [(and (>= char-int zero-int) (<= char-int nine-int)) (~a c)]
          [(and (>= char-int A-int) (<= char-int Z-int)) (~a (+ (- char-int A-int) 10))]
          [else null])))

;; substitute equivalent base 10 numbers for base 36 characters in string
;; this is a character-by-character substitution not a conversion
;; of a base36 number to a base10 number
(define (base36-string-characters->base10-string-characters s)
  (for/fold ([joined ""])
            ([tenstr (map base36-char->base10-string (string->list (string-upcase s)))])
    (values (string-append joined tenstr))))

;; This uses the Racket Luhn solution
(define [isin-test? s]
  (let ([RE (pregexp "^[A-Z]{2}[A-Z0-9]{9}[0-9]{1}$")])
    (and
     (regexp-match? RE s)
     (luhn-test (string->number (base36-string-characters->base10-string-characters s))))))

(define test-cases '("US0378331005" "US0373831005" "U50378331005" "US03378331005" "AU0000XVGZA3" "AU0000VXGZA3" "FR0000988040"))

(map isin-test? test-cases)
;; -> '(#t #f #f #f #t #t #t)
