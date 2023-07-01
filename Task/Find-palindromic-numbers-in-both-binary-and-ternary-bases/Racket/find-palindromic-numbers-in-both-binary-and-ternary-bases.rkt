#lang racket
(require racket/generator)

(define (digital-reverse/base base N)
  (define (inr n r)
    (if (zero? n) r (inr (quotient n base) (+ (* r base) (modulo n base)))))
  (inr N 0))

(define (palindrome?/base base N)
  (define (inr? n m)
    (if (= n 0)
        (= m N)
        (inr? (quotient n base) (+ (* m base) (modulo n base)))))
  (inr? N 0))

(define (palindrome?/3 n)
  (palindrome?/base 3 n))

(define (b-palindromes-generator b)
  (generator
   ()
   ;; it's a bit involved getting the initial palindroms, so we do them manually
   (for ((p (in-range b))) (yield p))
   (let loop ((rhs 1) (mx-rhs b) (mid #f) (mx-rhs*b (* b b)))
     (cond
       [(= rhs mx-rhs)
        (cond
          [(not mid) (loop (quotient mx-rhs b) mx-rhs 0 mx-rhs*b)]
          [(zero? mid) (loop mx-rhs mx-rhs*b #f (* mx-rhs*b b))])]
       [else
        (define shr (digital-reverse/base b rhs))
        (cond
          [(not mid)
           (yield (+ (* rhs mx-rhs) shr))
           (loop (add1 rhs) mx-rhs #f mx-rhs*b)]
          [(= mid (- b 1))
           (yield (+ (* rhs mx-rhs*b) (* mid mx-rhs) shr))
           (loop (+ 1 rhs) mx-rhs 0 mx-rhs*b)]
          [else
           (yield (+ (* rhs mx-rhs*b) (* mid mx-rhs) shr))
           (loop rhs mx-rhs (add1 mid) mx-rhs*b)])]))))

(define (number->string/base n b)
  (define (inr acc n)
    (if (zero? n) acc
        (let-values (((q r) (quotient/remainder n b)))
          (inr (cons (number->string r) acc) q))))
  (if (zero? n) "0" (apply string-append (inr null n))))

(module+ main
  (for ((n (sequence-filter palindrome?/3 (in-producer (b-palindromes-generator 2))))
        (i (in-naturals))
        #:final (= i 5))
    (printf "~a: ~a_10 ~a_3 ~a_2~%"
            (~a #:align 'right #:min-width  3 (add1 i))
            (~a #:align 'right #:min-width 11 n)
            (~a #:align 'right #:min-width 23 (number->string/base n 3))
            (~a #:align 'right #:min-width 37 (number->string/base n 2)))))

(module+ test
  (require rackunit)
  (check-true  (palindrome?/base 2 #b0))
  (check-true  (palindrome?/base 2 #b10101))
  (check-false (palindrome?/base 2 #b1010))
  (define from-oeis:A060792
    (list 0 1 6643 1422773 5415589 90396755477 381920985378904469
          1922624336133018996235 2004595370006815987563563
          8022581057533823761829436662099))
  (check-match from-oeis:A060792
               (list (? (curry palindrome?/base 2)
                        (? (curry palindrome?/base 3))) ...))

  (check-eq? (digital-reverse/base 2 #b0)        #b0)
  (check-eq? (digital-reverse/base 2 #b1)        #b1)
  (check-eq? (digital-reverse/base 2 #b10)      #b01)
  (check-eq? (digital-reverse/base 2 #b1010)  #b0101)

  (check-eq? (digital-reverse/base 10 #d0)       #d0)
  (check-eq? (digital-reverse/base 10 #d1)       #d1)
  (check-eq? (digital-reverse/base 10 #d10)     #d01)
  (check-eq? (digital-reverse/base 10 #d1010) #d0101)

  (define pg ((b-palindromes-generator 2)))
  (check-match
   (map (curryr number->string 2) (for/list ((i 16) (p (in-producer (b-palindromes-generator 2)))) p))
   (list "0" "1" "11" "101" "111" "1001" "1111" "10001" "10101" "11011"
         "11111" "100001" "101101" "110011" "111111" "1000001")))
