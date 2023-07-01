#lang racket/base

(require racket/match
         racket/string
         math/number-theory)

(define simplify-arithmetic-expression
  (letrec ((s-a-e
            (match-lambda
              [(list (and op '+) l ... (list '+ m ...) r ...) (s-a-e `(,op ,@l ,@m ,@r))]
              [(list (and op '+) l ... (? number? n1) m ... (? number? n2) r ...) (s-a-e `(,op ,@l ,(+ n1 n2) ,@m ,@r))]
              [(list (and op '+) (app s-a-e l _) ... 0 (app s-a-e r _) ...) (s-a-e `(,op ,@l ,@r))]
              [(list (and op '+) (app s-a-e x _)) (values x #t)]
              [(list (and op '*) l ... (list '* m ...) r ...) (s-a-e `(,op ,@l ,@m ,@r))]
              [(list (and op '*) l ... (? number? n1) m ... (? number? n2) r ...) (s-a-e `(,op ,@l ,(* n1 n2) ,@m ,@r))]
              [(list (and op '*) (app s-a-e l _) ... 1 (app s-a-e r _) ...) (s-a-e `(,op ,@l ,@r))]
              [(list (and op '*) (app s-a-e l _) ... 0 (app s-a-e r _) ...) (values 0 #t)]
              [(list (and op '*) (app s-a-e x _)) (values x #t)]
              [(list 'expt (app s-a-e x x-simplified?) 1) (values x x-simplified?)]
              [(list op (app s-a-e a #f) ...) (values `(,op ,@a) #f)]
              [(list op (app s-a-e a _) ...) (s-a-e `(,op ,@a))]
              [e (values e #f)])))
    s-a-e))

(define (expression->infix-string e)
  (define (parenthesise-maybe s p?)
    (if p? (string-append "(" s ")") s))

  (letrec ((e->is
            (lambda (paren?)
              (match-lambda
                [(list (and op (or '+ '- '* '*)) (app (e->is #t) a p?) ...)
                 (define bits (map parenthesise-maybe a p?))
                 (define compound (string-join bits (format " ~a " op)))
                 (values (if paren? (string-append "(" compound ")") compound) #f)]
                [(list 'expt (app (e->is #t) x xp?) (app (e->is #t) n np?))
                 (values (format "~a^~a" (parenthesise-maybe x xp?) (parenthesise-maybe n np?)) #f)]
                [(? number? (app number->string s)) (values s #f)]
                [(? symbol? (app symbol->string s)) (values s #f)]))))
    (define-values (str needs-parens?) ((e->is #f) e))
    str))

(define (faulhaber p)
  (define p+1 (add1 p))
  (define-values (simpler simplified?)
    (simplify-arithmetic-expression
     `(* ,(/ 1 p+1)
         (+ ,@(for/list ((j (in-range p+1)))
                `(* ,(* (expt -1 j)
                        (binomial p+1 j))
                    (* ,(bernoulli-number j)
                       (expt n ,(- p+1 j)))))))))
  simpler)

(for ((p (in-range 0 (add1 9))))
  (printf "f(~a) = ~a~%" p (expression->infix-string (faulhaber p))))
