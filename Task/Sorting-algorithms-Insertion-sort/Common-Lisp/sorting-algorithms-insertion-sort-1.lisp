(defun span (predicate list)
  (let ((tail (member-if-not predicate list)))
    (values (ldiff list tail) tail)))

(defun less-than (x)
  (lambda (y) (< y x)))

(defun insert (list elt)
  (multiple-value-bind (left right) (span (less-than elt) list)
    (append left (list elt) right)))

(defun insertion-sort (list)
  (reduce #'insert list :initial-value nil))
