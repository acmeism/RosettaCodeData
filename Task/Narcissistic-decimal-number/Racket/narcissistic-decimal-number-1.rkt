;; OEIS: A005188 defines these as positive numbers, so I will follow that definition in the function
;; definitions.
;;
;; 0: assuming it is represented as the single digit 0 (and not an empty string, which is not the
;;    usual convention for 0 in decimal), is not: sum(0^0), which is 1.  0^0 is a strange one,
;;    wolfram alpha calls returns 0^0 as indeterminate -- so I will defer to the brains behind OEIS
;;    on the definition here, rather than copy what I'm seeing in some of the results here
#lang racket

;; Included for the serious efficientcy gains we get from fxvectors vs. general vectors.
;;
;; We also use fx+/fx- etc. As it stands, they do a check for fixnumness, for safety.
;; We can link them in as "unsafe" operations (see the documentation on racket/fixnum);
;; but we get a result from this program quickly enough for my tastes.
(require racket/fixnum)

; uses a precalculated (fx)vector of powers -- caller provided, please.
(define (sub-narcissitic? N powered-digits)
  (let loop ((n N) (target N))
    (cond
      [(fx> 0 target) #f]
      [(fx= 0 target) (fx= 0 n)]
      [(fx= 0 n) #f]
      [else (loop (fxquotient n 10)
                  (fx- target (fxvector-ref powered-digits (fxremainder n 10))))])))

; Can be used as standalone, since it doesn't require caller to care about things like order of
; magnitude etc. However, it *is* slow, since it regenerates the powered-digits vector every time.
(define (narcissitic? n) ; n is +ve
  (define oom+1 (fx+ 1 (order-of-magnitude n)))
  (define powered-digits (for/fxvector ((i 10)) (expt i oom+1)))
  (sub-narcissitic? n powered-digits))

;; next m primes > z
(define (next-narcissitics z m) ; naming convention following math/number-theory's next-primes
  (let-values
      ([(i l)
        (for*/fold ((i (fx+ 1 z)) (l empty))
          ((oom (in-naturals))
           (dgts^oom (in-value (for/fxvector ((i 10)) (expt i (add1 oom)))))
           (n (in-range (expt 10 oom) (expt 10 (add1 oom))))
           #:when (sub-narcissitic? n dgts^oom)
           ; everyone else uses ^C to break...
           ; that's a bit of a manual process, don't you think?
           #:final (= (fx+ 1 (length l)) m))
          (values (+ i 1) (append l (list n))))])
    l)) ; we only want the list

(module+ main
  (next-narcissitics 0 25)
  ; here's another list... depending on whether you believe sloane or wolfram :-)
  (cons 0 (next-narcissitics 0 25)))

(module+ test
  (require rackunit)
  ; example given at head of task
  (check-true (narcissitic? 153))
  ; rip off the first 12 (and 0, since Armstrong numbers seem to be postivie) from
  ; http://oeis.org/A005188 for testing
  (check-equal?
   (for/list ((i (in-range 12))
              (n (sequence-filter narcissitic? (in-naturals 1)))) n)
   '(1 2 3 4 5 6 7 8 9 153 370 371))
  (check-equal? (next-narcissitics 0 12) '(1 2 3 4 5 6 7 8 9 153 370 371)))
