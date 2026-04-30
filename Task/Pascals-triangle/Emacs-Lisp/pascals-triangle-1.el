(require 'cl-lib)

(defun next-row (row)
  (cl-mapcar #'+ (cons 0 row)
                 (append row '(0))))

(defun triangle (row rows)
  (if (= rows 0)
      '()
    (cons row (triangle (next-row row) (- rows 1)))))
