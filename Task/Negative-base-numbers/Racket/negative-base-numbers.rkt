#lang racket

(define all-digits (string->list "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-"))

(define d->i-map (for/hash ((i (in-naturals)) (d all-digits)) (values d i)))

(define max-base (length all-digits))

(define (q/r n d)
  (let-values (((q r) (quotient/remainder n d)))
    (if (negative? r)
        (values (+ q 1) (- r d))
        (values q r))))

(define (negabase-convertors base)
  (when (not (integer? base)) (raise "Non-integer base."))
  (when (not (<= 2 (abs base) max-base)) (raise (format "(abs base) must be inside [2 ~a] interval." max-base)))
  (values
   (let ((q/r_base (curryr q/r base)))
     (λ (num)
       (define (checked->base num dig)
         (match num
           [0 (apply string dig)]
           [(app q/r_base num/ rst) (checked->base num/ (cons (list-ref all-digits rst) dig))]))
       (if (integer? num)
           (checked->base num  (if (zero? num) '(#\0) '()))
           (raise "Non-integer number."))))

   (λ (dig)
     (define (loop digs acc)
       (match digs [(list) acc] [(cons a d) (loop d (+ (* acc base) (hash-ref d->i-map a)))]))
     (loop (string->list dig) 0))))

(define-values (->negabinary negabinary->) (negabase-convertors -2))

(define-values (->negaternary negaternary->) (negabase-convertors -3))

(define-values (->negadecimal negadecimal->) (negabase-convertors -10))

(define-values (->nega63ary nega63ary->) (negabase-convertors (- max-base)))

(module+ main
  (->negaternary 146)
  (->negabinary 10)
  (->negadecimal 15)
  (->nega63ary -26238001742))

(module+ test
  (require rackunit)

  ;; tests from wikipedia page
  (check-equal? (call-with-values (λ () (q/r 146 -3)) cons) '(-48 . 2))
  (check-equal? (call-with-values (λ () (q/r -48 -3)) cons) '(16 . 0))
  (check-equal? (call-with-values (λ () (q/r 16 -3)) cons) '(-5 . 1))
  (check-equal? (call-with-values (λ () (q/r -5 -3)) cons) '(2 . 1))
  (check-equal? (call-with-values (λ () (q/r 2 -3)) cons) '(0 . 2))

  (define-values (->hexadecimal hexadecimal->) (negabase-convertors 16))
  (check-equal? (->hexadecimal 31) "1F"))
