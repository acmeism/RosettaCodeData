#lang racket
(require (planet jaymccarthy/dijkstra:1:2))

(define edges
  '([a . ((b 7)(c 9)(f 14))]
    [b . ((c 10)(d 15))]
    [c . ((d 11)(f 2))]
    [d . ((e 6))]
    [e . ((f 9))]))

(define (node-edges n)
  (cond [(assoc n edges) => rest] ['()]))
(define edge-weight second)
(define edge-end first)

(match/values (shortest-path node-edges edge-weight edge-end 'a (λ(n) (eq? n 'e)))
 [(dists prevs)
  (displayln (~a "Distances from a: " (for/list ([(n d) dists]) (list n d))))
  (displayln (~a "Shortest path: "
             (let loop ([path '(e)])
               (cond [(eq? (first path) 'a) path]
                     [(loop (cons (hash-ref prevs (first path)) path))]))))])
