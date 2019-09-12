#lang racket

;; using a builtin
(permutations '(A B C))
;; -> '((A B C) (B A C) (A C B) (C A B) (B C A) (C B A))

;; a random simple version (which is actually pretty good for a simple version)
(define (perms l)
  (let loop ([l l] [tail '()])
    (if (null? l) (list tail)
        (append-map (λ(x) (loop (remq x l) (cons x tail))) l))))
(perms '(A B C))
;; -> '((C B A) (B C A) (C A B) (A C B) (B A C) (A B C))

;; permutations in lexicographic order
(define (lperms s)
  (cond [(empty? s) '()]
        [(empty? (cdr s)) (list s)]
        [else
         (let splice ([l '()][m (car s)][r (cdr s)])
           (append
            (map (lambda (x) (cons m x)) (lperms (append l r)))
            (if (empty? r) '()
                (splice (append l (list m)) (car r) (cdr r)))))]))
(display (lperms '(A B C)))
;; -> ((A B C) (A C B) (B A C) (B C A) (C A B) (C B A))

;; permutations in lexicographical order using generators
(require racket/generator)
(define (splice s)
  (generator ()
             (let outer-loop ([l '()][m (car s)][r (cdr s)])
               (let ([permuter (lperm (append l r))])
                 (let inner-loop ([p (permuter)])
                   (when (not (void? p))
                     (let ([q (cons m p)])
                       (yield q)
                       (inner-loop (permuter))))))
               (if (not (empty? r))
                   (outer-loop (append l (list m)) (car r) (cdr r))
                   (void)))))
(define (lperm s)
  (generator ()
             (cond [(empty? s) (yield '())]
                   [(empty? (cdr s)) (yield s)]
                   [else
                    (let ([splicer (splice s)])
                      (let loop ([q (splicer)])
                        (when (not (void? q))
                          (begin
                            (yield q)
                            (loop (splicer))))))])
             (void)))
(let ([permuter (lperm '(A B C))])
  (let next-perm ([p (permuter)])
    (when (not (void? p))
      (begin
        (display p)
        (next-perm (permuter))))))
;; -> (A B C)(A C B)(B A C)(B C A)(C A B)(C B A)
