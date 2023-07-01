(define (max-subseq l)
  (define-values (_ result _1 max-sum)
    (for/fold ([seq '()] [max-seq '()] [sum 0] [max-sum 0])
      ([i l])
      (cond [(> (+ sum i) max-sum)
             (values (cons i seq) (cons i seq) (+ sum i) (+ sum i))]
            [(< (+ sum i) 0)
             (values '() max-seq 0 max-sum)]
            [else
             (values (cons i seq) max-seq (+ sum i) max-sum)])))
  (values (reverse result) max-sum))
