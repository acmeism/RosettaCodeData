; 1. Check the least significant bit.
(define (even? i)
   (if (eq? (band i 1) 0) #t #f))
(define (odd? i)
   (if (eq? (band i 1) 1) #t #f))

(print (if (even? 12345678987654321) "even" "odd")) ; ==> odd
(print (if (odd? 12345678987654321) "odd" "even"))  ; ==> odd
(print (if (even? 1234567898765432) "even" "odd"))  ; ==> even
(print (if (odd? 1234567898765432) "odd" "even"))   ; ==> even

; 2. Divide i by 2. The remainder equals 0 iff i is even.
(define (even? i)
   (if (eq? (remainder i 2) 0) #t #f))
(define (odd? i)
   (if (eq? (remainder i 2) 1) #t #f))

(print (if (even? 12345678987654321) "even" "odd")) ; ==> odd
(print (if (odd? 12345678987654321) "odd" "even"))  ; ==> odd
(print (if (even? 1234567898765432) "even" "odd"))  ; ==> even
(print (if (odd? 1234567898765432) "odd" "even"))   ; ==> even

; 3. Use modular congruences. Same as 2.
(define (even? i)
   (if (eq? (mod i 2) 0) #t #f))
(define (odd? i)
   (if (eq? (mod i 2) 1) #t #f))

(print (if (even? 12345678987654321) "even" "odd")) ; ==> odd
(print (if (odd? 12345678987654321) "odd" "even"))  ; ==> odd
(print (if (even? 1234567898765432) "even" "odd"))  ; ==> even
(print (if (odd? 1234567898765432) "odd" "even"))   ; ==> even
