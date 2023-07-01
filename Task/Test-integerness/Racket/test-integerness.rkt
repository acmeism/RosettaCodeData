#lang racket
(require tests/eli-tester)

(test ;; known representations of integers:
 ;; - as exacts
 (integer? -1) => #t
 (integer?  0) => #t
 (integer?  1) => #t
 (integer?   1234879378539875943875937598379587539875498792424323432432343242423432432) => #t
 (integer?  -1234879378539875943875937598379587539875498792424323432432343242423432432) => #t
 (integer?  #xff) => #t

 ;; - as inexacts
 (integer? -1.) => #t
 (integer?  0.) => #t
 (integer?  1.) => #t
 (integer?  1234879378539875943875937598379587539875498792424323432432343242423432432.) => #t
 (integer?  #xff.0) => #t
 ;; - but without a decimal fractional part
 (integer? -1.1) => #f

 ;; - fractional representation
 (integer? -42/3) => #t
 (integer?   0/1) => #t
 (integer?  27/9) => #t
 (integer?  #xff/f) => #t
 (integer?  #b11111111/1111) => #t
 ;; - but obviously not fractions
 (integer? 5/7) => #f

 ; - as scientific
 (integer?  1.23e2) => #t
 (integer?  1.23e120) => #t
 ; - but not with a small exponent
 (integer?  1.23e1) => #f

 ; - complex representations with 0 imaginary component
 ;   ℤ is a subset of the sets of rational and /real/ numbers and
 (integer? 1+0i) => #t
 (integer? (sqr 0+1i)) => #t
 (integer? 0+1i) => #f

 ;; oh, there's so much else that isn't an integer:
 (integer? "woo") => #f
 (integer? "100") => #f
 (integer? (string->number "22/11")) => #t ; just cast it!
 (integer? +inf.0) => #f
 (integer? -inf.0) => #f
 (integer? +nan.0) => #f ; duh! it's not even a number!
 (integer? -NaN.0) => #f
 (integer? pi) => #f
 )
