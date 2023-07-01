#lang racket

(define (collect-vars sexpr)
  (sort
   (remove-duplicates
    (let loop ([x sexpr])
      (cond [(boolean? x) '()]
            [(symbol? x) (list x)]
            [(list? x) (append-map loop (cdr x))]
            [else (error 'truth-table "Bad expression: ~e" x)])))
   string<? #:key symbol->string))

(define ns (make-base-namespace))

(define (truth-table sexpr)
  (define vars (collect-vars sexpr))
  (printf "~a => ~s\n" (string-join (map symbol->string vars)) sexpr)
  (for ([i (expt 2 (length vars))])
    (define vals
      (map (λ(x) (eq? #\1 x))
           (reverse (string->list (~r i #:min-width (length vars)
                                        #:pad-string "0"
                                        #:base 2)))))
    (printf "~a => ~a\n" (string-join (map (λ(b) (if b "T" "F")) vals))
            (if (eval `(let (,@(map list vars vals)) ,sexpr) ns) "T" "F"))))

(printf "Enter an expression: ")
(truth-table (read))
