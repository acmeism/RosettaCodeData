(use-package :iterate)
(defun print-tree (tree value-function children-function)
  (labels
      ((do-print-tree (tree prefix)
         (format t "~a~%" (funcall value-function tree))
         (iter
           (with children = (funcall children-function tree))
           (for child = (pop children))
           (while child)

           (if children
               (progn (format t "~a├─ " prefix)
                      (do-print-tree child (format nil "~a│  " prefix)))
               (progn (format t "~a└─ " prefix)
                      (do-print-tree child (format nil "~a   " prefix)))))))
    (do-print-tree tree "")))
