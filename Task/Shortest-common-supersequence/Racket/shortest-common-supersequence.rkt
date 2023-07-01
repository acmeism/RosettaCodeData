#lang racket

(struct link (len letters))

(define (link-add li n letter)
  (link (+ n (link-len li))
        (cons letter (link-letters li))))

(define (memoize f)
  (local ([define table (make-hash)])
    (lambda args
      (dict-ref! table args (λ () (apply f args))))))

(define scs/list
  (memoize
   (lambda (x y)
     (cond
       [(null? x)
        (link (length y) y)]
       [(null? y)
        (link (length x) x)]
       [(eq? (car x) (car y))
        (link-add (scs/list (cdr x) (cdr y)) 1 (car x))]
       [(<= (link-len (scs/list x (cdr y)))
            (link-len (scs/list (cdr x) y)))
        (link-add (scs/list x (cdr y)) 1 (car y))]
       [else
        (link-add (scs/list (cdr x) y) 1 (car x))]))))

(define (scs x y)
  (list->string (link-letters (scs/list (string->list x) (string->list y)))))

(scs "abcbdab" "bdcaba")
