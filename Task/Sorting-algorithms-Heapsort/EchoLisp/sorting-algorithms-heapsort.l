(lib 'heap)

(define (heap-sort list)
    (define heap (make-heap < )) ;; make a min heap
    (list->heap list heap)
    (while (not (heap-empty? heap))
          (push 'stack (heap-pop heap)))
    (stack->list 'stack))

(define L (shuffle (iota 15)))
    → (9 4 0 12 8 3 10 7 11 2 5 6 14 13 1)
(heap-sort L)
    → (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14)
