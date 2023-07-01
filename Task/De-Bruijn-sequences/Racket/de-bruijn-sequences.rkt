#lang racket

(define (de-bruijn k n)
  (define a (make-vector (* k n) 0))
  (define seq '())
  (define (db t p)
    (cond
      [(> t n) (when (= (modulo n p) 0)
                 (set! seq (cons (call-with-values
                                  (thunk (vector->values a 1 (add1 p)))
                                  list)
                                 seq)))]
      [else (vector-set! a t (vector-ref a (- t p)))
            (db (add1 t) p)
            (for ([j (in-range (add1 (vector-ref a (- t p))) k)])
              (vector-set! a t j)
              (db (add1 t) t))]))
  (db 1 1)
  (define seq* (append* (reverse seq)))
  (append seq* (take seq* (sub1 n))))

(define seq (de-bruijn 10 4))
(printf "The length of the de Bruijn sequence is ~a\n\n" (length seq))
(printf "The first 130 digits of the de Bruijn sequence are:\n~a\n\n"
        (take seq 130))
(printf "The last 130 digits of the de Bruijn sequence are:\n~a\n\n"
        (take-right seq 130))

(define (validate name seq)
  (printf "Validating the ~ade Bruijn sequence:\n" name)
  (define expected (for/set ([i (in-range 0 10000)]) i))
  (define actual (for/set ([a (in-list seq)]
                           [b (in-list (rest seq))]
                           [c (in-list (rest (rest seq)))]
                           [d (in-list (rest (rest (rest seq))))])
                   (+ (* 1000 a) (* 100 b) (* 10 c) d)))
  (define diff (set-subtract expected actual))
  (cond
    [(set-empty? diff) (printf "  No errors found\n")]
    [else (for ([n (in-set diff)])
            (printf "  ~a is missing\n" (~a n #:width 4 #:pad-string "0")))])
  (newline))

(validate "" seq)
(validate "reversed " (reverse seq))
(validate "overlaid " (list-update seq 4443 add1))
