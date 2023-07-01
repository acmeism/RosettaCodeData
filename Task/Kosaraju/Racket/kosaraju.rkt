#lang racket

(require racket/dict)

;; G is a dictionary of vertex -> (list vertex)
(define (Kosuraju G)
  (letrec
      ((vertices (remove-duplicates (append (dict-keys G) (append* (dict-values G)))))
       (visited?-dict (make-hash)) ; or any mutable dict type
       (assigned-dict (make-hash)) ; or any mutable dict type
       (neighbours:in (λ (u) (for/list (([v outs] (in-dict G)) #:when (member u outs)) v)))
       (visit! (λ (u L)
                 (cond [(dict-ref visited?-dict u #f) L]
                       [else (dict-set! visited?-dict u #t)
                             (cons u (for/fold ((L L)) ((v (in-list (dict-ref G u)))) (visit! v L)))])))
       (assign! (λ (u root)
                  (unless (dict-ref assigned-dict u #f)
                    (dict-set! assigned-dict u root)
                    (for ((v (in-list (neighbours:in u)))) (assign! v root)))))
       (L (for/fold ((l null)) ((u (in-dict-keys G))) (visit! u l))))

    (for ((u (in-list L))) (assign! u u))
    (map (curry map car) (group-by cdr (dict->list assigned-dict) =))))

(module+ test
  (Kosuraju '((0 1)
              (2 0)
              (5 2 6)
              (6 5)
              (1 2)
              (3 1 2 4) ; equvalent to (3 . (1 2 4))
              (4 5 3)
              (7 4 7 6))))
