(define (range n)
  (let ((lst '()))
    (do ((i 1 (+ i 1)))
        ((= i (+ n 1)))
      (set! lst (cons i lst)))
    (reverse lst)))

(define (fact n)
  (apply * (range n)))
