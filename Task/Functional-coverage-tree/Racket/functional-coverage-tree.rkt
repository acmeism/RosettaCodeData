#lang racket/base
(require racket/list racket/string racket/match racket/format racket/file)

(struct Coverage (name weight coverage weighted-coverage children) #:transparent #:mutable)

;; -| read/parse |------------------------------------------------------------------------------------
(define (build-hierarchies parsed-lines)
  (define inr
    (match-lambda
      ['() (values null null)]
      [`((,head-indent . ,C) ,tail-lines ...)
       (define child? (match-lambda [(cons i _) #:when (> i head-indent) #t] [_ #f]))
       (define-values (chlds rels) (splitf-at tail-lines child?))
       (define-values (rels-tree rels-rem) (inr rels))
       (values (cons (struct-copy Coverage C (children (build-hierarchies chlds))) rels-tree)
               rels-rem)]))
  (define-values (hierarchies remaining-lines) (inr parsed-lines))
  hierarchies)

(define report-line->indent.c/e-line
  (match-lambda
    [(regexp #px"^( *)([^ ]*) *\\| *([^ ]*) *\\| *([^ ]*) *\\|$"
             (list _
                   (app string-length indent-length)
                   name
                   (or (and (not "") (app string->number wght)) (app (λ (x) 1) wght))
                   (or (and (not "") (app string->number cvrg)) (app (λ (x) 0) cvrg))))
     (cons indent-length (Coverage name wght cvrg 0 #f))]))

(define (report->indent.c/e-list rprt)
  (map report-line->indent.c/e-line (drop (string-split rprt "\n") 1)))

;; -| evaluate |--------------------------------------------------------------------------------------
(define find-wght-cvrg
  (match-lambda
    [(and e (Coverage _ w c _ '())) (struct-copy Coverage e (weighted-coverage (* w c)))]
    [(and e (Coverage _ _ _ _ `(,(app find-wght-cvrg (and cdn+ (Coverage _ c-ws _ c-w/cs _))) ...)))
     (define chld-wghtd-avg (for/sum ((w (in-list c-ws)) (w/c (in-list c-w/cs))) (* w w/c)))
     (struct-copy Coverage e (weighted-coverage (/ chld-wghtd-avg (apply + c-ws))) (children cdn+))]))

;; -| printing |--------------------------------------------------------------------------------------
(define max-description-length
  (match-lambda
    [(Coverage (app string-length name-length) _ _ _
               (list (app max-description-length children-lengths) ...))
     (apply max name-length (map add1 children-lengths))]))

(define (~a/right w x)
  (~a x #:width w #:align 'right))

(define (~a/decimal n dec-dgts)
  (~a/right (+ dec-dgts 3) (if (zero? n) "" (real->decimal-string n dec-dgts))))

(define (print-coverage-tree tree)
  (define mdl (max-description-length tree))
  (printf "| ~a |WEIGT| COVER |WGHTD CVRG|~%" (~a "NAME" #:width mdl #:align 'center))
  (let inr ((depth 0) (tree tree))
    (unless (null? tree)
      (match tree
        [(Coverage name w c w/c chlds)
         (printf "| ~a | ~a | ~a | ~a |~%"
                 (~a (string-append (make-string depth #\space) name) #:width mdl)
                 (~a/right 3 w) (~a/decimal c 2) (~a/decimal w/c 5))
         (for ((c chlds)) (inr (add1 depth) c))]))))

;; ---------------------------------------------------------------------------------------------------
(module+ main
;; data/functional-coverage.txt contains a verbatim copy of
;; the table in the task's description
(for-each
 (compose print-coverage-tree find-wght-cvrg)
 (build-hierarchies (report->indent.c/e-list (file->string "data/functional-coverage.txt")))))
