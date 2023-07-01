#lang racket

(struct lev (n s t))

(define (lev-add old n sx tx)
  (lev (+ n (lev-n old))
       (cons sx (lev-s old))
       (cons tx (lev-t old))))

(define (list-repeat n v)
  (build-list n (lambda (_) v)))

(define (memoize f)
  (local ([define table (make-hash)])
    (lambda args
      (dict-ref! table args (λ () (apply f args))))))

(define levenshtein/list
  (memoize
   (lambda (s t)
     (cond
       [(and (empty? s) (empty? t))
        (lev 0 '() '())]
       [(empty? s)
        (lev (length t) (list-repeat (length t) #\-) t)]
       [(empty? t)
        (lev (length s) s (list-repeat (length s) #\-))]
       [else
        (if (equal? (first s) (first t))
            (lev-add (levenshtein/list (rest s) (rest t))
                     0 (first s) (first t))
            (argmin lev-n (list (lev-add (levenshtein/list (rest s) t)
                                         1 (first s) #\-)
                                (lev-add (levenshtein/list s (rest t))
                                         1 #\- (first t))
                                (lev-add (levenshtein/list (rest s) (rest t))
                                         1 (first s) (first t)))))]))))

(define (levenshtein s t)
  (let ([result (levenshtein/list (string->list s)
                                  (string->list t))])
    (values (lev-n result)
            (list->string (lev-s result))
            (list->string (lev-t result)))))
