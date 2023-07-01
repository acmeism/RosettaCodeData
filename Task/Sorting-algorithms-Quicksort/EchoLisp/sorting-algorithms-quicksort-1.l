(lib 'list) ;; list-partition

(define compare 0) ;; counter

(define (quicksort L compare-predicate: proc aux:  (part null))
(if  (<= (length L) 1) L
     (begin
     ;; counting the number of comparisons
     (set! compare (+ compare (length (rest L))))
      ;; pivot = first element of list
     (set! part (list-partition (rest L) proc (first L)))
     (append (quicksort (first part) proc )
            (list (first L))
            (quicksort (second part) proc)))))
