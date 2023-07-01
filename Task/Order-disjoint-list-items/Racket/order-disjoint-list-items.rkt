#lang racket
(define disjorder
  (match-lambda**
   (((list) n) '())
   ((m (list)) m)
   (((list h m-tail ...) (list h n-tail ...))
    (list* h (disjorder m-tail n-tail)))
   ;; the (not g/h) below stop greedy matching of the list which
   ;; would pick out orderings from the right first.
   (((list h (and (not g) m-tail-left) ... g m-tail-right ...)
     (list g (and (not h) n-tail-left) ... h n-tail-right ...))
    (disjorder `(,g ,@m-tail-left ,h ,@m-tail-right)
               `(,g ,@n-tail-left ,h ,@n-tail-right)))
   (((list h m-tail ...) n)
    (list* h (disjorder m-tail n)))))

(define (report-disjorder m n)
 (printf "Data M: ~a Order N: ~a -> ~a~%"
  (~a #:min-width 25 m) (~a #:min-width 10 n) (disjorder m n)))

;; Do the task tests
(report-disjorder '(the cat sat on the mat) '(mat cat))
(report-disjorder '(the cat sat on the mat) '(cat mat))
(report-disjorder '(A B C A B C A B C)      '(C A C A))
(report-disjorder '(A B C A B D A B E)      '(E A D A))
(report-disjorder '(A B)                    '(B))
(report-disjorder '(A B)                    '(B A))
(report-disjorder '(A B B A)                '(B A))
;; Do all of the other python tests
(report-disjorder '()            '())
(report-disjorder '(A)           '(A))
(report-disjorder '(A B)         '())
(report-disjorder '(A B B A)     '(A B))
(report-disjorder '(A B A B)     '(A B))
(report-disjorder '(A B A B)     '(B A B A))
(report-disjorder '(A B C C B A) '(A C A C))
(report-disjorder '(A B C C B A) '(C A C A))
