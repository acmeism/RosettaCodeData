(define-syntax ainc!
  (syntax-rules ()
    [(_ alist key val func default)
     (let ((pair (assoc key alist)))
       (if pair
         (set-cdr! pair (func val (cdr pair)))
         (set! alist (cons (cons key (func val default)) alist))))]
    [(_ alist key val func)
     (ainc! alist key val func 0)]
    [(_ alist key val)
     (ainc! alist key val +)]
    [(_ alist key)
     (ainc! alist key 1)]))

(define ulist '())

(for-each (cut  ainc! ulist <>) '(2 0 2 3 3 5 7 5 9 0))

(map car ulist)
  ===>
(9 7 5 3 0 2)
