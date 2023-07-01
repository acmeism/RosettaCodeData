(define position*
  (let ((memo (make-vector 118 #f)))
    (lambda (n)
      (let* ((mi (- n 1))
             (mp (vector-ref memo mi)))
        (or mp
            (let ((p (position n)))
              (vector-set! memo mi p)
              p))))))
