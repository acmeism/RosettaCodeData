#lang racket

(define (memoize f)
  (define table (make-hash))
  (λ args (hash-ref! table args (thunk (apply f args)))))

(struct $ (cost expl))
(define @ vector-ref)

(define (+: #:combine [combine (thunk* #f)] . xs)
  ($ (apply + (map $-cost xs)) (apply combine (map $-expl xs))))

(define (min: . xs) (argmin $-cost xs))

(define (compute dims)
  (define loop
    (memoize
     (λ (left right)
       (cond
         [(= 1 (- right left)) ($ 0 left)]
         [else (for/fold ([ans ($ +inf.0 #f)]) ([mid (in-range (add1 left) right)])
                 (min: ans (+: (loop left mid) (loop mid right)
                               ($ (* (@ dims left) (@ dims mid) (@ dims right)) #f)
                               #:combine (λ (left-answer right-answer _)
                                           (list left-answer '× right-answer)))))]))))
  (loop 0 (sub1 (vector-length dims))))
