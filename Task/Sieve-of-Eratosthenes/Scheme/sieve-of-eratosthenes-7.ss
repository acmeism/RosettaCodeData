 ;;;; Stream Implementation
 (define (head s) (car s))
 (define (tail s) ((cdr s)))
 (define-syntax s-cons
   (syntax-rules () ((s-cons h t) (cons h (lambda () t)))))

 ;;;; Stream Utility Functions
 (define (from-By x s)
   (s-cons x (from-By (+ x s) s)))
 (define (take n s)
   (cond
     ((> n 1) (cons (head s) (take (- n 1) (tail s))))
     ((= n 1) (list (head s)))      ;; don't force it too soon!!
     (else '())))     ;; so (take 4 (s-map / (from-By 4 -1))) works
 (define (drop n s)
   (cond
     ((> n 0) (drop (- n 1) (tail s)))
     (else s)))
 (define (s-map f s)
   (s-cons (f (head s)) (s-map f (tail s))))
 (define (s-diff s1 s2)
   (let ((h1 (head s1)) (h2 (head s2)))
    (cond
     ((< h1 h2) (s-cons h1 (s-diff  (tail s1)       s2 )))
     ((< h2 h1)            (s-diff        s1  (tail s2)))
     (else                 (s-diff  (tail s1) (tail s2))))))
 (define (s-union s1 s2)
   (let ((h1 (head s1)) (h2 (head s2)))
    (cond
     ((< h1 h2) (s-cons h1 (s-union (tail s1)       s2 )))
     ((< h2 h1) (s-cons h2 (s-union       s1  (tail s2))))
     (else      (s-cons h1 (s-union (tail s1) (tail s2)))))))
