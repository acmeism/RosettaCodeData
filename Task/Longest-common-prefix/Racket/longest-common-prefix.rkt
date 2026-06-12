#lang racket
(require srfi/1)

(define ε "")
(define lcp
  (match-lambda*
    [(list) ε]
    [(list a) a]
    [ss (list->string
         (reverse
          (let/ec k
            (fold (lambda (a d) (if (apply char=? a) (cons (car a) d) (k d))) null
                  (apply zip (map string->list ss))))))]))

(module+ test
  (require tests/eli-tester)
  (test
   (lcp "interspecies" "interstellar" "interstate") => "inters"
   (lcp "throne" "throne") => "throne"
   (lcp "throne" "dungeon") => ""
   (lcp "cheese") => "cheese"
   (lcp ε) => ε
   (lcp) => ε
   (lcp "prefix" "suffix") => ε))
