#lang racket
(define dep-tree ; go straight for the hash, without parsing strings etc.
  #hash((top1  . (des1 ip1 ip2))
        (top2  . (des1 ip2 ip3))
        (ip1   . (extra1 ip1a ipcommon))
        (ip2   . (ip2a ip2b ip2c ipcommon))
        (des1  . (des1a des1b des1c))
        (des1a . (des1a1 des1a2))
        (des1c . (des1c1 extra1))))

(define (build-tree Deps Top)
  (define (build n b# d)
    (hash-set b# n d))

  (define (inner-b-t node visited built# depth)
    (cond
      [(hash-ref built# node #f)
       built#]
      [(member node visited)
       (error 'build-tree "circular dependency tree at node: ~a" node)]
      [(hash-ref Deps node #f)
       =>
       (λ (deps)
         (define built#+
           (for/fold ((built# built#)) ((dependency deps))
             (if (equal? dependency node)
                 built#
                 (inner-b-t dependency (cons node visited) built# (add1 depth)))))
         (build node built#+ depth))]
      [else
       (build node built# depth)]))

  (define final-build# (inner-b-t Top null (hash) 1))

  (define levels# (for/fold ((hsh# (hash))) (([k v] (in-hash final-build#)))
                    (hash-update hsh# v (curry cons k) null)))

  (for/list ((lvl (in-list (sort (hash-keys levels#) >))))
    (hash-ref levels# lvl)))

(define (print-build-order Deps Top)
  (define build-order (build-tree Deps Top))
  (printf "To build: ~s~%" Top)
  (for ((round build-order)) (printf "Build: ~a~%" round))
  (newline))

(print-build-order dep-tree 'top1)
(print-build-order dep-tree 'top2)
(with-handlers [(exn? (λ (x) (displayln (exn-message x) (current-error-port))))]
  (build-tree #hash((top . (des1 ip1)) (ip1 . (net netip)) (netip . (mac ip1))) 'top))
