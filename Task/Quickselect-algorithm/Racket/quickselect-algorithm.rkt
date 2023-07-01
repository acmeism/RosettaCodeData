(define (quickselect A k)
  (define pivot (list-ref A (random (length A))))
  (define A1 (filter (curry > pivot) A))
  (define A2 (filter (curry < pivot) A))
  (cond
    [(<= k (length A1)) (quickselect A1 k)]
    [(> k (- (length A) (length A2))) (quickselect A2 (- k (- (length A) (length A2))))]
    [else pivot]))

(define a '(9 8 7 6 5 0 1 2 3 4))
(display (string-join (map number->string (for/list ([k 10]) (quickselect a (+ 1 k)))) ", "))
