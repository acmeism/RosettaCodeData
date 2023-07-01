#lang racket

(define (quotient/remainder-egyptian dividend divisor (trace? #f))
  (define table
    (for*/list ((power_of_2 (sequence-map (curry expt 2) (in-naturals)))
                (doubling (in-value (* divisor power_of_2)))
                #:break (> doubling dividend))
      (list power_of_2 doubling)))

  (when trace?
    (displayln "Table\npow_2\tdoubling")
    (for ((row table)) (printf "~a\t~a~%" (first row) (second row))))

  (define-values (answer accumulator)
    (for*/fold ((answer 0) (accumulator 0))
               ((row (reverse table))
                (acc′ (in-value (+ accumulator (second row)))))
      (when trace? (printf "row:~a\tans/acc:~a ~a\t" row answer accumulator))
      (cond
        [(<= acc′ dividend)
         (define ans′ (+ answer (first row)))
         (when trace? (printf "~a <= ~a -> ans′/acc′:~a ~a~%" acc′ dividend ans′ acc′))
         (values ans′ acc′)]
        [else
         (when trace? (printf "~a > ~a [----]~%" acc′ dividend))
         (values answer accumulator)])))

  (values answer (- dividend accumulator)))

(module+ test
  (require rackunit)
  (let-values (([q r] (quotient/remainder-egyptian 580 34)))
    (check-equal? q 17)
    (check-equal? r 2))

  (let-values (([q r] (quotient/remainder-egyptian 192 3)))
    (check-equal? q 64)
    (check-equal? r 0)))

(module+ main
  (quotient/remainder-egyptian 580 34 #t))
