(define (combine-ng-cf->cf ng cf)
  (define empty-producer? #f)
  (lambda ()
    (let loop ()
      (cond
        [(not empty-producer?) (define t (cf))
                               (cond
                                   [t (ng-ingress! ng t)
                                      (if (ng-needterm? ng)
                                          (loop)
                                          (ng-egress! ng))]
                                   [else (set! empty-producer? #t)
                                         (loop)])]
        [(ng-done? ng) #f]
        [(ng-needterm? ng) (ng-infty! ng)
                           (loop)]
        [else (ng-egress! ng)]))))

(define (cf-showln cf n)
  (for ([i (in-range n)])
    (define val (cf))
    (when val
      (printf " ~a" val)))
  (when (cf)
    (printf " ..."))
  (printf "~n"))
