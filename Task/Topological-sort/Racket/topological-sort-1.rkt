#lang racket

(define G
  (make-hash
   '((des_system_lib . (std synopsys std_cell_lib des_system_lib dw02
                            dw01 ramlib ieee))
     (dw01           . (ieee dw01 dware gtech))
     (dw02           . (ieee dw02 dware))
     (dw03           . (std synopsys dware dw03 dw02 dw01 ieee gtech))
     (dw04           . (dw04 ieee dw01 dware gtech))
     (dw05           . (dw05 ieee dware))
     (dw06           . (dw06 ieee dware))
     (dw07           . (ieee dware))
     (dware          . (ieee dware))
     (gtech          . (ieee gtech))
     (ramlib         . (std ieee))
     (std_cell_lib   . (ieee std_cell_lib))
     (synopsys       . ()))))

(define (clean G)
  (define G* (hash-copy G))
  (for ([(from tos) G])
    ; remove self dependencies
    (hash-set! G* from (remove from tos))
    ; make sure all nodes are present in the ht
    (for ([to tos]) (hash-update! G* to (λ(_)_) '())))
  G*)

(define (incoming G)
  (define in (make-hash))
  (for* ([(from tos) G] [to tos])
    (hash-update! in to (λ(fs) (cons from fs)) '()))
  in)

(define (nodes G)       (hash-keys G))
(define (out G n)       (hash-ref G n '()))
(define (remove! G n m) (hash-set! G n (remove m (out G n))))

(define (topo-sort G)
  (define n (length (nodes G)))
  (define in (incoming G))
  (define (no-incoming? n) (empty? (hash-ref in n '())))
  (let loop ([L '()] [S (list->set (filter no-incoming? (nodes G)))])
    (cond [(set-empty? S)
           (if (= (length L) n)
               L
               (error 'topo-sort (~a "cycle detected" G)))]
          [else
           (define n   (set-first S))
           (define S\n (set-rest S))
           (for ([m (out G n)])
             (remove! G n m)
             (remove! in m n)
             (when (no-incoming? m)
               (set! S\n (set-add S\n m))))
           (loop (cons n L) S\n)])))

(topo-sort (clean G))
