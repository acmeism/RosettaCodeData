#lang racket/base
(require racket/match)
(define (merge-lists as . bss)
  (match bss
    ['() as]
    [(cons b bt)
     (apply merge-lists
            (for*/list ((a (in-list as)) (b (in-list b))) (append a b))
            bt)]))

(define (get-item cs depth)
  (let loop ((out '(())) (cs cs))
    (match cs
      ['() (values out cs)]
      [`(,(or #\, #\}) . ,more) #:when (positive? depth) (values out cs)]
      [`(#\{ . ,more)
       (=> no-group-match)
       (define-values (group-out group-rem) (get-group more (add1 depth) no-group-match))
       (loop (merge-lists out group-out) group-rem)]
      [(or `(#\\ ,c ,more ...) `(,c . ,more)) (loop (merge-lists out (list (list c))) more)])))

(define (get-group cs depth no-group-match)
  (let loop ((out '()) (cs cs) (comma? #f))
    (when (null? cs) (no-group-match))
    (define-values (item-out item-rem) (get-item cs depth))
    (when (null? item-rem) (no-group-match))
    (let ((out (append out item-out)))
      (match item-rem
        [`(#\} . ,more) #:when comma? (values out more)]
        [`(#\} . ,more) (values (merge-lists '((#\{)) out '((#\}))) more)]
        [`(#\, . ,more) (loop out more #t)]
        [_ (no-group-match)]))))

(define (brace-expand s)
  (let-values (([out rem] (get-item (string->list s) 0))) (map list->string out)))

(module+ test
  (define patterns
    (list
     "~/{Downloads,Pictures}/*.{jpg,gif,png}"
     "It{{em,alic}iz,erat}e{d,}, please."
     #<<P
{,{,gotta have{ ,\, again\, }}more }cowbell!
P
     #<<P
{}} some }{,{\\\\{ edge, edge} \,}{ cases, {here} \\\\\\\\\}
P
     ))
  (for ((s (in-list patterns)) #:when (printf "expand: ~a~%" s) (x (in-list (brace-expand s))))
    (printf "\t~a~%" x)))
