(define (make-queue)
  (make-vector 1 '()))

(define (push a queue)
  (vector-set! queue 0 (append (vector-ref queue 0) (list a))))

(define (empty? queue)
  (null? (vector-ref queue 0)))

(define (pop queue)
  (if (empty? queue)
      (error "can not pop an empty queue")
      (let ((ret (car (vector-ref queue 0))))
        (vector-set! queue 0 (cdr (vector-ref queue 0)))
        ret)))
