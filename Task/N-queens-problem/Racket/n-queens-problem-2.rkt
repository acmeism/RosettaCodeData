(require htdp/show-queen)

(define (show-nqueens n)
  (define qs (time (nqueens n)))
  (show-queen
   (for/list ([row n])
     (for/list ([col n])
       (if (member (Q row col) qs) #t #f)))))

(show-nqueens 8)
