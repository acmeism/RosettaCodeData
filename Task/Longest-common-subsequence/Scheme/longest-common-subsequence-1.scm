;; using srfi-69
(define (memoize proc)
  (let ((results (make-hash-table)))
    (lambda args
      (or (hash-table-ref results args (lambda () #f))
          (let ((r (apply proc args)))
            (hash-table-set! results args r)
            r)))))

(define (longest xs ys)
  (if (> (length xs)
         (length ys))
      xs ys))

(define lcs
  (memoize
   (lambda (seqx seqy)
     (if (pair? seqx)
         (let ((x (car seqx))
               (xs (cdr seqx)))
           (if (pair? seqy)
               (let ((y (car seqy))
                     (ys (cdr seqy)))
                 (if (equal? x y)
                     (cons x (lcs xs ys))
                     (longest (lcs seqx ys)
                              (lcs xs seqy))))
               '()))
         '()))))
