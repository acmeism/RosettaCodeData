#!r6rs

(import (rnrs)
        (rnrs eval)
        (only (srfi :1 lists) append-map delete-duplicates iota))

(define (map* fn . lis)
  (if (null? lis)
      (list (fn))
      (append-map (lambda (x)
                    (apply map*
                           (lambda xs (apply fn x xs))
                           (cdr lis)))
                  (car lis))))

(define (insert x li n)
  (if (= n 0)
      (cons x li)
      (cons (car li) (insert x (cdr li) (- n 1)))))

(define (permutations li)
  (if (null? li)
      (list ())
      (map* insert (list (car li)) (permutations (cdr li)) (iota (length li)))))

(define (evaluates-to-24 expr)
  (guard (e ((assertion-violation? e) #f))
    (= 24 (eval expr (environment '(rnrs base))))))

(define (tree n o0 o1 o2 xs)
  (list-ref
   (list
    `(,o0 (,o1 (,o2 ,(car xs) ,(cadr xs)) ,(caddr xs)) ,(cadddr xs))
    `(,o0 (,o1 (,o2 ,(car xs) ,(cadr xs)) ,(caddr xs)) ,(cadddr xs))
    `(,o0 (,o1 ,(car xs) (,o2 ,(cadr xs) ,(caddr xs))) ,(cadddr xs))
    `(,o0 (,o1 ,(car xs) ,(cadr xs)) (,o2 ,(caddr xs) ,(cadddr xs)))
    `(,o0 ,(car xs) (,o1 (,o2 ,(cadr xs) ,(caddr xs)) ,(cadddr xs)))
    `(,o0 ,(car xs) (,o1 ,(cadr xs) (,o2 ,(caddr xs) ,(cadddr xs)))))
   n))

(define (solve a b c d)
  (define ops '(+ - * /))
  (define perms (delete-duplicates (permutations (list a b c d))))
  (delete-duplicates
   (filter evaluates-to-24
           (map* tree (iota 6) ops ops ops perms))))
