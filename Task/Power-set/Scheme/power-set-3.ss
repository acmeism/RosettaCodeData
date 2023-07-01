(define (power_set_iter set)
  (let loop ((res '(())) (s set))
    (if (empty? s)
        res
        (loop (append (map (lambda (i) (cons (car s) i)) res) res) (cdr s)))))
