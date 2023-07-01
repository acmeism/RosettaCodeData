;priority-queue's are implemented with association lists
(defun make-pq (alist)
  (sort (copy-alist alist) (lambda (a b) (< (car a) (car b)))))
;
;Will change the state of pq
;
(define-modify-macro insert-pq (pair)
                     (lambda (pq pair) (sort-alist (cons pair pq))))

(define-modify-macro remove-pq-aux () cdr)

(defmacro remove-pq (pq)
  `(let ((aux (copy-alist ,pq)))
     (REMOVE-PQ-AUX ,pq)
     (car aux)))
;
;Will not change the state of pq
;
(defun insert-pq-non-destructive (pair pq)
  (sort-alist (cons pair pq)))

(defun remove-pq-non-destructive (pq)
  (cdr pq))
;testing
(defparameter a (make-pq '((1 . "Solve RC tasks") (3 . "Clear drains") (2 . "Tax return") (5 . "Make tea"))))
(format t "~a~&" a)
(insert-pq a '(4 . "Feed cat"))
(format t "~a~&" a)
(format t "~a~&" (remove-pq a))
(format t "~a~&" a)
(format t "~a~&" (remove-pq a))
(format t "~a~&" a)
