(define ((rational->cf n d))
  (and (not (zero? d))
       (let-values ([(q r) (quotient/remainder n d)])
         (set! n d)
         (set! d r)
         q)))

(define (sqrt2->cf)
  (define first? #t)
  (lambda ()
    (if first?
        (begin
          (set! first? #f)
          1)
        2)))
