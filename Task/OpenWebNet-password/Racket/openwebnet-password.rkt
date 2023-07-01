#lang racket/base
(define (32-bit-truncate n)
  (bitwise-and n #xFFFFFFFF))

(define (own-calc-pass password-string nonce)
  (define-values (num-1 flag)
    (for/fold ((num-1 0) (flag #t))
              ((c (in-string nonce)))
      (let* ((num-1 (32-bit-truncate num-1))
             (num-2 (if flag (string->number password-string) num-1)))

        (define (and-right-left-add mask right left)
          (values (+ (arithmetic-shift (bitwise-and num-2 mask) (- right))
                     (arithmetic-shift num-2 left))
                  #f))

        (define (left-right-add left right)
          (values (+ (arithmetic-shift num-2 left) (arithmetic-shift num-2 (- right))) #f))

        (define (stage-7)
          (values (+ (+ (+ (bitwise-and num-2 #xff00)
                           (arithmetic-shift (bitwise-and num-2 #xff) 24))
                        (arithmetic-shift (bitwise-and num-2 #xff0000) -16))
                     (arithmetic-shift (bitwise-and num-2 #xFF000000) -8))
                  #f))

        (define (stage-8)
          (values (+ (+ (arithmetic-shift (bitwise-and num-2 #xffff) 16)
                        (arithmetic-shift num-2 -24))
                     (arithmetic-shift (bitwise-and num-2 #xff0000) -8))
                  #f))

        (define (stage-9) (values (bitwise-not num-2) #f))

        (case c
          ([#\1] (and-right-left-add #xFFFFFF80 7 25))
          ([#\2] (and-right-left-add #xFFFFFFF0 4 28))
          ([#\3] (and-right-left-add #xFFFFFFF8 3 29))
          ([#\4] (left-right-add 1 31))
          ([#\5] (left-right-add 5 27))
          ([#\6] (left-right-add 12 20))
          ([#\7] (stage-7))
          ([#\8] (stage-8))
          ([#\9] (stage-9))
          (else (values num-1 flag))))))
  (32-bit-truncate num-1))

(module+ test
  (require rackunit)

  (define (own-test-calc-pass passwd nonce expected)
    (let* ((res (own-calc-pass passwd nonce))
           (msg (format "~a ~a ~a ~a" passwd nonce res expected)))
      (string-append (if (= res expected) "PASS" "FAIL") " " msg)))


  (own-test-calc-pass "12345" "603356072" 25280520)
  (own-test-calc-pass "12345" "410501656" 119537670))
