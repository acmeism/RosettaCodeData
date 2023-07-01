(import (scheme base)
        (scheme write))

;; convert number to a list of digits, in desired base
(define (number->list n base)
  (let loop ((res '())
             (num n))
    (if (< num base)
      (cons num res)
      (loop (cons (remainder num base) res)
            (quotient num base)))))

;; return the sum of digits of n in given base
(define (sum-digits n base)
  (apply + (number->list n base)))

;; test cases:
;; -- this displays each number in its original, given-base, for comparison
;; -- target-base is the base in which to consider each number represented, for summing the digits
(define (test-case n given-base target-base)
  (display (string-append (number->string n given-base)
                          " base "
                          (number->string given-base)
                          " has decimal value "
                          (number->string n)
                          " => sum of digits in base "
                          (number->string target-base)
                          " is "
                          (number->string (sum-digits n target-base))))
  (newline))

(test-case 1 10 10)
(test-case 1234 10 10)
(test-case #o1234 8 10)
(test-case #xFE 16 16)
(test-case #xFE 16 10)
(test-case #xF0E 16 16)
(test-case #b1101010101010101010101010101010101 2 2)
(test-case #b1101010101010101010101010101010101 2 10)
(test-case #b1101010101010101010101010101010101 2 1000)
