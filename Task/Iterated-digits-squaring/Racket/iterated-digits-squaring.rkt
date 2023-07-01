#lang racket
;; Tim-brown 2014-09-11

;; The basic definition.
;; It is possible to memoise this or use fixnum (native) arithmetic, but frankly iterating over a
;; hundred million, billion, trillion numbers will be slow. No matter how you do it.
(define (digit^2-sum n)
  (let loop ((n n) (s 0))
    (if (= 0 n) s (let-values ([(q r) (quotient/remainder n 10)]) (loop q (+ s (sqr r)))))))

(define (iterated-digit^2-sum n)
  (match (digit^2-sum n) [0 0] [1 1] [89 89] [(app iterated-digit^2-sum rv) rv]))

;; Note that: ids(345) = ids(354) = ids(435) = ids(453) = ids(534) = ids(543) = 50 --> 89
;; One calculation does for 6 candidates.
;; The plan:
;;  - get all the ordered combinations of digits including 0's which can be used both as digits and
;;    "padding" digits in the most significant digits. (n.b. all-zeros is not in the range to be
;;    tested and should be dropped)
;;  - find the digit sets that have an IDS of 89
;;  - find out how many combinations there are of these digits

;; output: a list of n-digits long lists containing all of the digit combinations.
;;         a smart bunny would figure out the sums of the digits as they're generated but I'll plod
;;         along step-by-step. a truly smart bunny would also count the combinations. that said, I
;;         don't think I do much unnecessary computation here.
(define (all-digit-lists n-digits)
  (define (inner remain acc least-digit)
    (cond
      [(zero? remain) (list (list))]
      [(= least-digit 10) null]
      [else
       (for*/list
           ((ld+ (in-range least-digit 10))
            (rgt (in-list (inner (sub1 remain) empty ld+))))
         (append acc (cons ld+ rgt)))]))
  (inner n-digits '() 0))

;; We calculate IDS differently since we're presented with a list of digits rather than a number
(define (digit-list-IDS c)
  (define (digit-combo-IDS c)
    (apply + (map sqr c)))
  (iterated-digit^2-sum (digit-combo-IDS c)))

;; ! (factiorial) -- everyone's favourite combinatorial function! (that's just an exclamation mark)
;; there's one in (require math/number-theory) for any heavy lifting, but we're not or I could import
;; it from math/number-theory -- but this is about all I need. A lookup table is going to be faster
;; than a more general function.
(define (! n)
  (case n [(0 1) 1] [(2) 2] [(3) 6] [(4) 24] [(5) 120] [(6) 720] [(7) 5040] [(8) 40320] [(9) 362880]
    [else (* n (! (sub1 n)))] ; I expect this clause'll never be called
    ))

;; We need to count the permutations -- digits are in order so we can use the tail (cdr) function for
;; determining my various k's. See: https://en.wikipedia.org/wiki/Combination
(define (count-digit-list-permutations c #:length (l (length c)) #:length! (l! (! l)))
  (let loop ((c c) (i 0) (prev -1 #;"never a digit") (p l!))
    (match c
      [(list) (/ p (! i))]
      [(cons (== prev) d) (loop d (+ i 1) prev p)]
      [(cons a d) (loop d 1 a (/ p (! i)))])))

;; Wrap it all up in a neat function
(define (count-89s-in-100... n)
  (define n-digits (order-of-magnitude n))
  (define combos (drop (all-digit-lists n-digits) 1)) ; don't want first one which is "all-zeros"
  (for/sum ((c (in-list combos)) #:when (= 89 (digit-list-IDS c)))
    (count-digit-list-permutations c #:length n-digits)))

(displayln "Testing permutations:")
(time (printf "1000000:\t~a~%"        (count-89s-in-100...       1000000)))
(time (printf "100000000:\t~a~%"      (count-89s-in-100...     100000000)))
(time (printf "1000000000:\t~a~%"     (count-89s-in-100...    1000000000)))
(time (printf "1000000000000:\t~a~%"  (count-89s-in-100... 1000000000000)))
(newline)
;; Do these last, since the 10^8 takes longer than my ADHD can cope with
(displayln "Testing one number at a time (somewhat slower):")
(time (printf "1000000:\t~a~%"   (for/sum ((n (in-range 1   1000000))
                                           #:when (= 89 (iterated-digit^2-sum n))) 1)))
(time (printf "100000000:\t~a~%" (for/sum ((n (in-range 1 100000000))
                                           #:when (= 89 (iterated-digit^2-sum n))) 1)))

{module+ test
  (require tests/eli-tester)
  [test
   (iterated-digit^2-sum 15) => 89
   (iterated-digit^2-sum 7) => 1
   (digit-combo-perms '()) => 1
   (digit-combo-perms '(1 2 3)) => 6
   (digit-combo-perms '(1 1 3)) => 3
   (for/sum ((n (in-range 1 1000000)) #:when (= 89 (iterated-digit^2-sum n))) 1) => 856929
   (all-digit-lists 1) => '((0) (1) (2) (3) (4) (5) (6) (7) (8) (9))
   (length (all-digit-lists 2)) => 55
   (length (all-digit-lists 3)) => 220
   (count-89s-in-100... 1000000) => 856929]
  }
