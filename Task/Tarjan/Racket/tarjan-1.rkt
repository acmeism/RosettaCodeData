#lang racket

(require syntax/parse/define
         fancy-app
         (for-syntax racket/syntax))

(struct node (name index low-link on?) #:transparent #:mutable
  #:methods gen:custom-write
  [(define (write-proc v port mode) (fprintf port "~a" (node-name v)))])

(define-syntax-parser change!
  [(_ x:id f) #'(set! x (f x))]
  [(_ accessor:id v f)
   #:with mutator! (format-id this-syntax "set-~a!" #'accessor)
   #'(mutator! v (f (accessor v)))])

(define (tarjan g)
  (define sccs '())
  (define index 0)
  (define s '())

  (define (dfs v)
    (set-node-index! v index)
    (set-node-low-link! v index)
    (set-node-on?! v #t)
    (change! s (cons v _))
    (change! index add1)

    (for ([w (in-list (hash-ref g v '()))])
      (match-define (node _ index low-link on?) w)
      (cond
        [(not index) (dfs w)
                     (change! node-low-link v (min (node-low-link w) _))]
        [on? (change! node-low-link v (min index _))]))

    (when (= (node-low-link v) (node-index v))
      (define-values (scc* s*) (splitf-at s (λ (w) (not (eq? w v)))))
      (set! s (rest s*))
      (define scc (cons (first s*) scc*))
      (for ([w (in-list scc)]) (set-node-on?! w #f))
      (change! sccs (cons scc _))))

  (for* ([(u _) (in-hash g)] #:when (not (node-index u))) (dfs u))
  sccs)

(define (make-graph xs)
  (define store (make-hash))
  (define (make-node v) (hash-ref! store v (thunk (node v #f #f #f))))

  ;; it's important that we use hasheq instead of hash so that we compare
  ;; reference instead of actual value. Had we use the actual value,
  ;; the key would be a mutable value, which causes undefined behavior
  (for/hasheq ([vs (in-list xs)]) (values (make-node (first vs)) (map make-node (rest vs)))))

(tarjan (make-graph '([0 1]
                      [2 0]
                      [5 2 6]
                      [6 5]
                      [1 2]
                      [3 1 2 4]
                      [4 5 3]
                      [7 4 7 6])))
